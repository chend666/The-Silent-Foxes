# Loading Libraries and Data
import re # for regular expressions
import pandas as pd 
pd.set_option("display.max_colwidth", 200)
import numpy as np 
import matplotlib.pyplot as plt 
import seaborn as sns
import string
import nltk # for text manipulation
from nltk.stem.porter import *
from sklearn.feature_extraction.text import TfidfVectorizer, CountVectorizer
import gensim
import warnings 
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import f1_score
warnings.filterwarnings("ignore", category=DeprecationWarning)
import wordninja

with open('postgres_public_data_allegation.csv') as f:
    df = pd.read_csv(f)
f.close()
data  = pd.read_csv('postgres_public_data_allegation.csv')
narratives = pd.read_csv('narratives.csv',
                         usecols=['cr_id', 'column_name', 'text'],
                         dtype={"cr_id": "string", "column_name": "string", "text": "string"})
def clean(text):
  if text in ['(None Entered)', 'NO AFFIDAVIT']: return ''

  text = text.replace('\n', ' ').replace('|', 'I').strip()

  text = ' '.join([word for token in text.split() for word in (wordninja.split(token) if token.isalpha() else [token])])
  return text

narratives['text'] = narratives.loc[:,'text'].map(clean)
narratives = narratives[narratives['text'] != '']


data2 = narratives.reset_index()

train = data.head(1200)
test = data.tail(400)
pred = data2

train[train['is_officer_complaint'] == True].head(10)
train[train['is_officer_complaint'] == False].head(10)
train["is_officer_complaint"].value_counts()

length_train = train['summary'].str.len()
length_test = test['summary'].str.len()
length_pred = pred['text'].str.len()


combi = train.append(test, ignore_index=True)

combi2 = pred

def remove_pattern(input_txt, pattern):
    r = re.findall(pattern, input_txt)
    for i in r:
        input_txt = re.sub(i, '', input_txt)
        
    return input_txt    


# Removing Handles
combi['tidy_summary'] = np.vectorize(remove_pattern)(combi['summary'], "@[\w]*") 
combi2['tidy_summary'] = np.vectorize(remove_pattern)([str(x) for x in combi2['text']], "@[\w]*") 
# Removing Punctuations, Numbers, and Special Characters
combi['tidy_summary'] = combi['tidy_summary'].str.replace("[^a-zA-Z#]", " ")
combi2['tidy_summary'] = combi2['tidy_summary'].str.replace("[^a-zA-Z#]", " ")
# Removing Short Words
combi['tidy_summary'] = combi['tidy_summary'].apply(lambda x: ' '.join([w for w in x.split() if len(w)>3]))
combi2['tidy_summary'] = combi2['tidy_summary'].apply(lambda x: ' '.join([w for w in x.split() if len(w)>3]))
# et’s take another look at the first few rows of the combined dataframe.

tokenized_tweet = combi['tidy_summary'].apply(lambda x: x.split()) # tokenizing
tokenized_tweet2 = combi2['tidy_summary'].apply(lambda x: x.split()) # tokenizing

stemmer = PorterStemmer()

tokenized_tweet = tokenized_tweet.apply(lambda x: [stemmer.stem(i) for i in x]) # stemming
tokenized_tweet2 = tokenized_tweet2.apply(lambda x: [stemmer.stem(i) for i in x]) # stemming

for i in range(len(tokenized_tweet)):
    tokenized_tweet[i] = ' '.join(tokenized_tweet[i])

for i in range(len(tokenized_tweet2)):
    tokenized_tweet2[i] = ' '.join(tokenized_tweet2[i])
    
combi['tidy_summary'] = tokenized_tweet
combi2['tidy_summary'] = tokenized_tweet2

combi2 = combi2[combi2['tidy_summary'].notna()]


# Bag-of-Words Features
bow_vectorizer = CountVectorizer(max_df=0.90, min_df=2, max_features=1000, stop_words='english')
bow = bow_vectorizer.fit_transform(combi['tidy_summary'])
bow2 = bow_vectorizer.fit_transform(combi2['tidy_summary'])



tfidf_vectorizer = TfidfVectorizer(max_df=0.90, min_df=2, max_features=1000, stop_words='english')
tfidf = tfidf_vectorizer.fit_transform(combi['tidy_summary'])
tfidf2 = tfidf_vectorizer.fit_transform(combi2['tidy_summary'])


tokenized_tweet = combi['tidy_summary'].apply(lambda x: x.split()) # tokenizing
tokenized_tweet2 = combi2['tidy_summary'].apply(lambda x: x.split())

model_w2v = gensim.models.Word2Vec(
            tokenized_tweet,  # desired no. of features/independent variables 
            window=5, # context window size
            min_count=2,
            sg = 1, # 1 for skip-gram model
            hs = 0,
            negative = 10, # for negative sampling
            workers= 2, # no.of cores
            seed = 34)

model_w2v.train(tokenized_tweet, total_examples= len(combi['tidy_summary']), epochs=20)

model_w2v.wv.most_similar(positive="good")
model_w2v.wv.most_similar(positive="beat")

# Bag-of-Words Features
train_bow = bow[:1147,:]
test_bow = bow[1147:,:]

# splitting data into training and validation set
xtrain_bow, xvalid_bow, ytrain, yvalid = train_test_split(train_bow, train['is_officer_complaint'],  
                                                          random_state=42, 
                                                          test_size=0.3)

lreg = LogisticRegression()
lreg.fit(xtrain_bow, ytrain) # training the model

prediction = lreg.predict_proba(xvalid_bow) # predicting on the validation set
prediction_int = prediction[:,1] >= 0.3 # if prediction is greater than or equal to 0.3 than 1 else 0
prediction_int = prediction_int.astype(np.int)

# Now let's make predictions for the test dataset and create a submission file.
test_pred = lreg.predict_proba(test_bow)
test_pred_int = test_pred[:,1] >= 0.3
test_pred_int = test_pred_int.astype(np.int)
test['is_officer_complaint'] = test_pred_int
submission = test[['beat_id','is_officer_complaint']]
submission.to_csv('sub_lreg_bow.csv', index=False) # writing data to a CSV file

# TF-IDF Features
train_tfidf = tfidf[:1147,:]
test_tfidf = tfidf[1147:,:]

xtrain_tfidf = train_tfidf[ytrain.index]
xvalid_tfidf = train_tfidf[yvalid.index]



lreg.fit(xtrain_tfidf, ytrain)

prediction = lreg.predict_proba(xvalid_tfidf)
prediction_int = prediction[:,1] >= 0.3
prediction_int = prediction_int.astype(np.int)

prediction2 = lreg.predict_proba(tfidf2)
prediction_int2 = prediction2[:,1] >= 0.3
prediction_int2 = prediction_int2.astype(np.int)

t = 0
f = 0

for i in prediction_int2:
    if i == 0:
        f+=1
    else:
        t+=1
print('-----------------------------------------')
print('Result:')
print('number of officer complaint: ' + str(t))
print('number of not officer complaint: ' + str(f))
print('total number of allegation narratives: '  + str(t+f))
