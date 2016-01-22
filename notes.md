# Presidents

## Load in from CSV
```sql
TRUNCATE TABLE intermediate_sql.presidents;

LOAD DATA LOCAL

    INFILE "/Users/henryxie/Development/teaching/intermediate-sql/data/presidents.csv"

    INTO TABLE intermediate_sql.presidents

    FIELDS
        TERMINATED BY ','
        ENCLOSED BY '"'

    LINES
        TERMINATED BY '\n'

    IGNORE 1 LINES
    (
        id, last_name, first_name, middle_name, @date_of_birth, @date_of_death,
        home_state, party, @date_took_office, @date_left_office, @assassination_attempt,
        @assassinated, religion
    )

    SET date_of_birth = CASE WHEN @date_of_birth != ''
                            THEN STR_TO_DATE(@date_of_birth, '%m/%d/%Y')
                            ELSE NULL
                        END,
        date_of_death = CASE WHEN @date_of_death !=''
                            THEN STR_TO_DATE(@date_of_death, '%m/%d/%Y')
                            ELSE NULL
                        END,
        date_took_office = CASE WHEN @date_took_office !=''
                            THEN STR_TO_DATE(@date_took_office, '%m/%d/%Y')
                            ELSE NULL
                        END,
        date_left_office = CASE WHEN @date_left_office !=''
                            THEN STR_TO_DATE(@date_left_office, '%m/%d/%Y')
                            ELSE NULL
                        END,
        assassination_attempt = @assassination_attempt = 'true',
        assassinated = @assassinated = 'true'
    ;
```
- This demonstrates how to read in CSV files into a SQL table.
- Use `SET` to "convert" fields before insertion.
- Use `CASE` to add logic.


## Review
1. How many US presidents have there been? How many are dead now?
```sql
SELECT
    COUNT(*) as president_count,
    COUNT(date_of_death) AS num_dead_presidents
FROM
    intermediate_sql.presidents
;```

- This reviews `COUNT`. Recall that it only counts non-NULL values.

2. Which presidents are still alive and how old are they?
```sql
SELECT
    first_name, middle_name, last_name, FLOOR(DATEDIFF(current_date(), date_of_birth)/365) as age
FROM
    intermediate_sql.presidents
WHERE
    date_of_death IS NULL
;```
- Reviews use of functions.


3. How can we format the president names to first M. last?
```sql
SELECT
    CASE WHEN middle_name != ''
        THEN CONCAT(first_name, ' ', LEFT(middle_name, 1), '. ', last_name)
        ELSE CONCAT(first_name, ' ', last_name)
    END as full_name
FROM
    intermediate_sql.presidents
;```
- Reviews `CONCAT` and `CASE` logic.


4. Get the top 3 states by president count:
```sql
SELECT
    home_state,
    COUNT(*) AS state_count
FROM
    intermediate_sql.presidents
GROUP BY
    home_state
ORDER BY state_count DESC
LIMIT 3;
```
- This reviews basic GROUP BY syntax.


5. Order the presidents by state and last name.
```sql
SELECT home_state, last_name, first_name
FROM intermediate_sql.presidents
ORDER BY home_state, last_name;
```

6. Get count of state/first_name pairs in descending order
```sql
SELECT home_state, first_name, COUNT(*)
FROM intermediate_sql.presidents
GROUP BY home_state, first_name
ORDER BY COUNT(*) DESC, home_state, first_name;
```

7. Which states have given birth to more than two presidents after 1900?
```sql
SELECT home_state, count(*) as counter
FROM intermediate_sql.presidents
WHERE date_of_birth >= '1900-01-01'
GROUP BY home_state
HAVING counter > 1
ORDER BY counter DESC;
```

8. Which presidents were alive during WW II?
```sql
SELECT last_name, home_state, date_of_birth, date_of_death
FROM intermediate_sql.presidents
WHERE date_of_death > '1939-09-01'
AND date_of_birth < '1945-09-02';
```


## Subqueries

1. Get list of presidents from top three states by president count
```sql
SELECT last_name, home_state
FROM intermediate_sql.presidents
WHERE home_state IN (
    SELECT home_state
    FROM intermediate_sql.presidents
    GROUP BY home_state
    HAVING COUNT(*) >= (
        SELECT MIN(state_count)
        FROM (
            SELECT COUNT(*) as state_count
            from intermediate_sql.presidents
            GROUP BY home_state
            ORDER BY state_count DESC
            LIMIT 3
        ) as t3
    )
)
ORDER BY home_state, last_name, first_name;
```

2. Get the oldest president in each state

2A. Create a view for the age of the presidents
```sql
DROP VIEW IF EXISTS intermediate_sql.presidents_age;
CREATE VIEW intermediate_sql.presidents_age AS
    SELECT last_name, home_state, COALESCE(
        FLOOR(DATEDIFF(date_of_death, date_of_birth) / 365),
        FLOOR(DATEDIFF(CURRENT_DATE(), date_of_birth) / 365)
    ) as age
    FROM intermediate_sql.presidents;
SELECT *
FROM intermediate_sql.presidents_age
ORDER BY age DESC;
```

2B. Create count, average/max/min age columns for each state in a view
```sql
DROP VIEW IF EXISTS intermediate_sql.presidents_agg;
CREATE VIEW intermediate_sql.presidents_agg AS
    SELECT
        home_state,
        count(home_state) as state_count,
        ROUND(AVG(age), 1) as avg_age,
        MIN(age) as min_age,
        MAX(age) as max_age
    FROM intermediate_sql.presidents_age
    GROUP BY home_state
    ORDER BY state_count DESC;
SELECT *
FROM intermediate_sql.presidents_agg;
```

2C. Join our age table with our agg table
```sql
SELECT sub.home_state, sub.last_name, sub.age
FROM intermediate_sql.presidents_age sub
INNER JOIN intermediate_sql.presidents_agg sub2
ON sub.home_state = sub2.home_state AND sub.age = sub2.max_age
ORDER BY
    age DESC,
    home_state,
    last_name
;```
