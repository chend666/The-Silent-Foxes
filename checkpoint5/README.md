## Checkpoint 5 Graph Analytics

### Q1 Can we train a transformer-based language model to identify the officer complaint from allegation narratives?
```
How to run:

Open and run 'summary & is_officer_complaint.ipynb' inside 'src/' in Jupter Notebook with Python language

You will get two F1 scores as the accuracy of our model, one for Bag-of-Words feature, the other for TF-IDF features

```


### Q2 Is the number of officer complaint records in allegation narratives consistent with existing data?
```
How to run:

To predict from allegation narratives:
1. in terminal, run 'pip3 -r requirements.txt'
2. run 'prediction.py'

It will print out the prediction result.
Note: it currently reads 'narratives.csv' as input text for prediction. 
If you want to predict your own documents, please change the file name to 'narratives.csv' 
or change the code in 'prediction.py', and make sure you have the field called 'text'
```
