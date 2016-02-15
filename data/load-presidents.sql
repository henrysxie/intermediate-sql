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