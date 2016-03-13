# Review
1. How many US presidents have there been? How many are dead now?

    ```sql
    SELECT
        COUNT(*) as president_count,
        COUNT(date_of_death) AS num_dead_presidents
    FROM
        intermediate_sql.presidents
    ;
    ```

    - This reviews `COUNT`. Recall that it only counts non-NULL values.

2. Which presidents are still alive and how old are they?

    ```sql
    SELECT
        first_name, middle_name, last_name, FLOOR(DATEDIFF(current_date(), date_of_birth)/365) as age
    FROM
        intermediate_sql.presidents
    WHERE
        date_of_death IS NULL
    ;
    ```
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
    ;
    ```
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
    - Can order by multiple columns.

6. Get count of state/first_name pairs in descending order
    ```sql
    SELECT home_state, first_name, COUNT(*)
    FROM intermediate_sql.presidents
    GROUP BY home_state, first_name
    ORDER BY COUNT(*) DESC, home_state, first_name;
    ```
    - Can use tuples for GROUP BY.

    - Notice that Grover Cleveland of New York comes up as a dupe. To fix:
    ```sql
    SELECT home_state, first_name, COUNT(*)
    FROM (
        SELECT * FROM sql_trial.presidents
        GROUP BY first_name, middle_name, last_name
    ) as unique_presidents
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
    - `HAVING` modifies post-grouping records, whereas `WHERE` limits pre-grouping records.

8. Which presidents were alive during WW II?
    ```sql
    SELECT last_name, home_state, date_of_birth, date_of_death
    FROM intermediate_sql.presidents
    WHERE date_of_death > '1939-09-01'
    AND date_of_birth < '1945-09-02';
    ```
    - Can combine conditions in `WHERE` clause.

## Flights: JOINS
1. How many routes are there that originate in JFK?
    ```sql
    SELECT COUNT(*)
    FROM intermediate_sql.routes r
    JOIN intermediate_sql.airports a
    ON r.origin_id = a.id
    WHERE a.iata_faa = 'JFK';
    ;
    ```
    - Answer: 456
    - Can use JOIN or subquery.


2. How many routes are there that end up at JFK?
    ```sql
    SELECT COUNT(*)
    FROM intermediate_sql.routes r
    JOIN intermediate_sql.airports a
    ON r.dest_id = a.id
    WHERE a.iata_faa = 'JFK';
    ;
    ```
    - Answer: 455

3. How many airlines does the US have?

    ```sql
    SELECT COUNT(*)
    FROM sql_trial.airlines
    WHERE country = 'United States'
    AND active = 'Y';
    ```
    - Answer: 141

4. How many airports are there in the US?
    ```sql
    SELECT COUNT(*) FROM sql_trial.airports
    WHERE country = 'United States';
    ```
    - Answer: 1697

## Subqueries

1. Which president was born most recently?

    WRONG:
    ```sql
    SELECT * FROM intermediate_sql.presidents
    WHERE date_of_birth = MAX(date_of_birth);
    ```
    - Cannot use aggregates in WHERE clauses.

    CORRECT:
    ```sql
    SELECT *
    FROM intermediate_sql.presidents
    WHERE date_of_birth = (
        SELECT MAX(birth)
        FROM intermediate_sql.presidents
    );
    ```

2. Which are the top 10 airports that have the highest difference in incoming vs. outgoing routes?
    ```sql
    SELECT incoming.code, inflow, outflow, ABS(inflow - outflow) as diff
    from (
        (SELECT
            a.iata_faa as code,
            COUNT(a.iata_faa) as inflow
        FROM intermediate_sql.routes r
        JOIN intermediate_sql.airports a
        ON r.dest_id = a.id
        GROUP BY a.iata_faa) as incoming

        JOIN (SELECT
            a.iata_faa as code,
            COUNT(a.iata_faa) as outflow
        FROM intermediate_sql.routes r
        JOIN intermediate_sql.airports a
        ON r.origin_id = a.id
        GROUP BY a.iata_faa) as outgoing

        ON incoming.code = outgoing.code

    )
    ORDER BY diff DESC
    LIMIT 10;
    ```

    - Uses both JOIN and subqueries.
    - Inner queries get incoming and outgoing flights for each airport. The outer JOIN then combines these two together.


3. Get list of presidents from top three states by president count
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
    1. Inner query lists the top there states with their counts.
    2. Next extracts the minimum of those counts.
    3. Next out lists the states with that count or higher.
    4. Outermost query takes presidents whose state falls in that list.


## Views

1. Get the oldest president in each state

    A. Create a view for the age of the presidents

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
    - A view is like a virtual table. It keeps that data in place, for later queries.

    B. Create count, average/max/min age columns for each state in a view

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

    C. Join our age table with our agg table

    ```sql
    SELECT sub.home_state, sub.last_name, sub.age
    FROM intermediate_sql.presidents_age sub
    INNER JOIN intermediate_sql.presidents_agg sub2
    ON sub.home_state = sub2.home_state AND sub.age = sub2.max_age
    ORDER BY
        age DESC,
        home_state,
        last_name
    ;
    ```
    - `JOIN` condition handles the max age requirement.


# Data Modeling
1. WE DO: Author, Books, and Editions
    - Use EER diagram in MySQL Workbench
    - Forward engineer tables to create them
    - Models
        - Author
            - first_name
            - last_name
            - middle_name
            - dob
            - dod
        - Book
            - title
            - ISBN
        - Edition
            - edition
    - Relationships
        - Author M2M Book
        - Edition FK -> Book

2. YOU DO: Purchases
    - Purchase
    - Customer
    - Store
    - Product


# Indexes

1. Index
    - Create iata_faa index on airports table.
    - Look at query stats for the following query.

    ```sql
    SELECT * FROM sql_trial.airports
    WHERE iata_faa in ('JFK', 'LAX');
    ```

2. Unique constraint
    - Create unique together constraint for date_took_office, and date_left_office.
    - Show that the following insert fails:

    ```sql
    INSERT INTO intermediate_sql.presidents
    (last_name, first_name, date_of_birth, home_state, party, date_took_office, date_left_office)
    VALUES ('Trump', 'Donald', '1946-06-14', 'New York', 'Republican', '2001-01-20', '2009-01-20');
    ```

# Loading from CSV

```sql
DROP TABLE IF EXISTS intermediate_sql.presidents;

CREATE TABLE intermediate_sql.presidents (
    id MEDIUMINT NOT NULL AUTO_INCREMENT,
    last_name VARCHAR(255) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    middle_name VARCHAR(255),
    date_of_birth DATE NOT NULL,
    date_of_death DATE,
    home_state VARCHAR(100) NOT NULL,
    party VARCHAR(255) NOT NULL,
    date_took_office DATE,
    date_left_office DATE,
    assassination_attempt BOOLEAN DEFAULT FALSE,
    assassinated BOOLEAN DEFAULT FALSE,
    religion VARCHAR(255),
    PRIMARY KEY (id)
);

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
