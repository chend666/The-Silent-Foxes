-- checkout allegation category of officers who got awards
SELECT dac.category,data_officerallegation.allegation_category_id, data_officerallegation.officer_id
from data_officerallegation
    JOIN data_allegationcategory dac ON data_officerallegation.allegation_category_id = dac.id
Where
    NOT EXISTS(
        SELECT NULL
        FROM  data_award da
        WHERE data_officerallegation.officer_id = da.officer_id
        )
ORDER BY officer_id;

-- checkout the result: category and its amount for officers who got awards
SELECT dac.category, count(dac.category)
from data_officerallegation
    JOIN data_allegationcategory dac ON data_officerallegation.allegation_category_id = dac.id
Where
    NOT EXISTS(
        SELECT NULL
        FROM  data_award da
        WHERE data_officerallegation.officer_id = da.officer_id
        )
GROUP BY dac.category ORDER BY dac.category;

-- output: allegation_category_award.csv

-- checkout allegation category of officers who did not get any awards
SELECT dac.category, data_officerallegation.allegation_category_id, data_officerallegation.officer_id
from data_officerallegation
    JOIN data_allegationcategory dac ON data_officerallegation.allegation_category_id = dac.id
Where EXISTS(
        SELECT da.officer_id
        FROM  data_award da
        WHERE data_officerallegation.officer_id = da.officer_id
)
ORDER BY officer_id;
-- checkout the result: category and its amount for officers who did not get awards
SELECT dac.category, count(dac.category)
from data_officerallegation
    JOIN data_allegationcategory dac ON data_officerallegation.allegation_category_id = dac.id
Where EXISTS(
        SELECT da.officer_id
        FROM  data_award da
        WHERE data_officerallegation.officer_id = da.officer_id
)
GROUP BY dac.category ORDER BY dac.category;

-- output: allegation_category_unaward.csv