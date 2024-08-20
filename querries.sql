/*5 querries*/
USE TopGitHubRepos;

-- 1
-- querry one, select with a where clause
-- this select gets all authors with a country starting with c
SELECT * 
	FROM author
    WHERE Birth_Country LIKE "c%";


-- 2
-- querry two, select with an inner join
-- this select looks at how many git repos are ceterain type of programming language
SELECT lang_type, COUNT(*) as "# of languages"
	FROM git_repo
	INNER JOIN language USING(lang_name)
	GROUP BY lang_type
	ORDER BY COUNT(*) DESC;


-- 3
-- select with a group by statment
-- this counts the langauges developed after the year 2000 in each language type
SELECT lang_type, COUNT(*) AS "# of languages", CAST(AVG(lang_year) AS DECIMAL(10,0)) AS "Average development Year"
	FROM language
	where lang_year > 2000
	GROUP BY lang_type
	ORDER BY COUNT(*) DESC;


-- 4
-- subquerry in a from clause
-- finds the average # of emploees per country
SELECT CAST(AVG(the_count) AS DECIMAL(10,1)) AS "avg # of employees per country" 
	FROM (SELECT birth_country, COUNT(*) AS the_count
		FROM author
		INNER JOIN country ON (country_name = birth_country)
		GROUP BY birth_country
		ORDER BY COUNT(*) DESC) AA;

	
-- 5	
-- view and querry
-- authors contributions to git hub repos, and the diff between their lowest and highest star repo

-- view creation
DROP VIEW IF EXISTS author_lang_project;
CREATE VIEW author_lang_project AS (
	SELECT author_name, lang_name, COUNT(repo_name) AS repo_count, MAX(stars) - MIN(stars) AS star_dif
		FROM author_lang
        INNER JOIN language USING (lang_name)
        INNER JOIN git_repo USING (lang_name)
        GROUP BY author_name, lang_name);

-- select all from view
SELECT * FROM author_lang_project;

-- round stars and divide by 1000 to show stars per 1000
UPDATE git_repo
	SET stars = ROUND(stars, - 3) / 1000
    WHERE lang_name <> 'xyz';
    
-- second select
SELECT author_name, lang_name, repo_count, star_dif AS star_dif_per_1000
	FROM author_lang_project;