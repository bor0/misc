CREATE DATABASE IF NOT EXISTS aoc;
USE aoc;

DROP TABLE IF EXISTS aoc2;
CREATE TABLE aoc2 (command CHAR(20) CHARACTER SET utf8 COLLATE utf8_bin);

SET GLOBAL local_infile=1;
LOAD DATA LOCAL INFILE 'input' INTO TABLE aoc2;

SET @forward := (SELECT SUM(REPLACE(command, "forward", "")) FROM aoc2 WHERE command LIKE 'forward%');
SET @down := (SELECT SUM(REPLACE(command, "down", "")) FROM aoc2 WHERE command LIKE 'down%');
SET @up := (SELECT SUM(REPLACE(command, "up", "")) FROM aoc2 WHERE command LIKE 'up%');

SELECT @forward * (@down - @up);
