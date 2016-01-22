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