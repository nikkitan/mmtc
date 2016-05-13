CREATE DATABASE `mmtc` /*!40100 DEFAULT CHARACTER SET utf8 */;

CREATE TABLE `user` (
  `pk` bigint(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `email` varchar(255) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`username`),
  UNIQUE KEY `pk_UNIQUE` (`pk`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `authorities` (
  `authority` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  UNIQUE KEY `authorities_idx_1` (`authority`,`username`),
  KEY `fk_authorities_user1_idx` (`username`),
  CONSTRAINT `fk_authorities_user1` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `groups` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `group_authorities` (
  `authority` varchar(50) NOT NULL,
  `groups_id` bigint(11) NOT NULL,
  PRIMARY KEY (`authority`),
  KEY `fk_group_authorities_groups1_idx` (`groups_id`),
  CONSTRAINT `fk_group_authorities_groups1` FOREIGN KEY (`groups_id`) REFERENCES `groups` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `group_members` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `groups_id` bigint(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_group_members_groups1_idx` (`groups_id`),
  CONSTRAINT `fk_group_members_groups1` FOREIGN KEY (`groups_id`) REFERENCES `groups` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `testsuite` (
  `pk` bigint(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`pk`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

CREATE TABLE `test` (
  `pk` bigint(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `question` longtext NOT NULL,
  `createdat` datetime NOT NULL,
  `updatedat` datetime NOT NULL,
  `options` longtext NOT NULL,
  `answer` varchar(50) NOT NULL,
  `testsuite_pk` bigint(11) NOT NULL,
  `keywords` longtext,
  `pic` varchar(255) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `serial` int(11) NOT NULL,
  `watchword` longtext,
  `tips` longtext,
  PRIMARY KEY (`serial`,`testsuite_pk`),
  UNIQUE KEY `pk` (`pk`),
  KEY `fk_test_2_testsuite_idx` (`testsuite_pk`),
  CONSTRAINT `fk_test_2_testsuite` FOREIGN KEY (`testsuite_pk`) REFERENCES `testsuite` (`pk`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1798 DEFAULT CHARSET=utf8;


CREATE TABLE `test_taking` (
  `pk` bigint(11) NOT NULL AUTO_INCREMENT,
  `student_answer` varchar(45) DEFAULT NULL,
  `user_username` varchar(50) NOT NULL,
  `test_pk` bigint(11) NOT NULL,
  `grade_pk` bigint(11) NOT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `duration_in_sec` int(11) DEFAULT NULL,
  `grade` int(11) DEFAULT NULL,
  `passing_grade` varchar(45) DEFAULT NULL,
  `duration_limit_sec` int(11) DEFAULT '7200',
  PRIMARY KEY (`pk`),
  KEY `fk_test_performance_user_idx` (`user_username`),
  KEY `fk_test_performance_test1_idx` (`test_pk`),
  KEY `fk_test_performance_grade1_idx` (`grade_pk`),
  CONSTRAINT `fk_test_performance_test1` FOREIGN KEY (`test_pk`) REFERENCES `test` (`pk`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_test_performance_user` FOREIGN KEY (`user_username`) REFERENCES `users` (`username`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `test_pic` (
  `pk` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`pk`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `webvisitor` (
  `pk` int(11) NOT NULL AUTO_INCREMENT,
  `fn` mediumtext,
  `ln` mediumtext,
  `email` varchar(255) DEFAULT NULL,
  `msg` mediumtext,
  `weblead` int(11) DEFAULT NULL,
  PRIMARY KEY (`pk`),
  UNIQUE KEY `pk_UNIQUE` (`pk`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

CREATE TABLE `weblead` (
  `pk` int(11) NOT NULL AUTO_INCREMENT,
  `name` mediumtext NOT NULL,
  `count` bigint(11) DEFAULT NULL,
  PRIMARY KEY (`pk`),
  UNIQUE KEY `pk_UNIQUE` (`pk`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
