/*stored procedures*/
USE TopGitHubRepos;

-- PROCEDURE 1 --------------------------
DROP PROCEDURE IF EXISTS develop_new_lang;
DELIMITER $$
CREATE PROCEDURE develop_new_lang(IN new_lang VARCHAR(50), IN new_type VARCHAR(50), IN new_lang_year VARCHAR(50),IN new_author VARCHAR(50), IN new_birth_country VARCHAR(50))
BEGIN
START TRANSACTION;

-- insert author name
INSERT IGNORE INTO author (author_name, birth_country) VALUES 
(new_author, new_birth_country);

-- insert lang name
INSERT IGNORE INTO language (lang_name, lang_type, lang_year) VALUES
	(new_lang, new_type, new_lang_year);
  
-- insert author lang
INSERT IGNORE INTO author_lang (lang_name, author_name) VALUES
	(new_lang, new_author);

COMMIT;
END;
$$
DELIMITER ;


-- PROCEDURE 2 --------------------------
DROP PROCEDURE IF EXISTS update_git_repo;
DELIMITER $$
CREATE PROCEDURE update_git_repo(IN lang_to_remove VARCHAR(50), INOUT num_removed INT, INOUT num_updated INT, IN lang_to_update VARCHAR(50), IN new_lang_name VARCHAR(50))
BEGIN
START TRANSACTION;

-- get number of removed rows
SET num_removed = num_removed + (SELECT COUNT(*) 
									FROM git_repo
									WHERE lang_name LIKE lang_to_remove); 
   
-- get num of updated rows
SET num_updated = num_updated + (SELECT COUNT(*) 
									FROM git_repo
									WHERE lang_name LIKE lang_to_update); 

-- remove rows
DELETE FROM git_repo
	WHERE lang_name LIKE lang_to_remove; 
  
-- update rows
UPDATE language
    SET lang_name = new_lang_name
    WHERE lang_name LIKE lang_to_update;
    
COMMIT;
END;
$$
DELIMITER ;

-- call P1 
CALL develop_new_lang("maxs lang", "assembly", "2023", "Max Hayden", "Canada");

-- call  P2
SET @num_removed_to_pass:= 0;
SET @num_updated_to_pass:= 0;
CALL update_git_repo('ActionScript', @num_removed_to_pass, @num_updated_to_pass, 'cpp', 'c++');
SELECT @num_removed_to_pass, @num_updated_to_pass;