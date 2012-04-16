SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;


CREATE TABLE models (
  id int(11) NOT NULL auto_increment,
  user_id int(11) NOT NULL,
  `name` varchar(255) collate utf8_bin NOT NULL,
  md2filename varchar(255) collate utf8_bin NOT NULL,
  texturefilename varchar(255) collate utf8_bin NOT NULL,
  updated timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  created timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (id)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE objects (
  id int(11) NOT NULL auto_increment,
  user_id int(11) NOT NULL,
  `type` int(11) NOT NULL,
  model_id int(11) NOT NULL,
  title varchar(255) collate utf8_bin NOT NULL,
  url varchar(255) collate utf8_bin NOT NULL,
  description text collate utf8_bin NOT NULL,
  latitude double NOT NULL,
  longitude double NOT NULL,
  altitude double NOT NULL,
  picfilename varchar(255) collate utf8_bin NOT NULL,
  updated timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  created timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (id)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE settings (
  id int(11) NOT NULL auto_increment,
  s_key varchar(255) collate utf8_unicode_ci default NULL,
  s_value varchar(255) collate utf8_unicode_ci default NULL,
  created timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (id)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE users (
  id int(11) NOT NULL auto_increment,
  permission varchar(255) collate utf8_bin NOT NULL,
  loginname varchar(255) collate utf8_bin NOT NULL,
  `password` varchar(255) collate utf8_bin NOT NULL,
  email varchar(255) collate utf8_bin NOT NULL,
  updated timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  created timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (id)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO `users` (`id`, `permission`, `loginname`, `password`, `email`, `updated`, `created`) VALUES
(1, 'admin', 'admin', 'admin', 'demo@example.com', '2010-04-10 10:28:04', '2010-04-08 14:55:14'));
