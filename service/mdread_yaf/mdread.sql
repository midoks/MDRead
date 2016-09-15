-- --------------------------------------------------------
-- 主机:                           121.42.151.169
-- 服务器版本:                        5.5.48-log - Source distribution
-- 服务器操作系统:                      Linux
-- HeidiSQL 版本:                  8.3.0.4694
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- 导出 mdread 的数据库结构
CREATE DATABASE IF NOT EXISTS `mdread` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `mdread`;


-- 导出  表 mdread.md_app 结构
CREATE TABLE IF NOT EXISTS `md_app` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `app_name` varchar(50) NOT NULL DEFAULT '',
  `app_key` varchar(11) NOT NULL DEFAULT '',
  `update_time` int(11) NOT NULL,
  `create_time` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

-- 数据导出被取消选择。


-- 导出  表 mdread.md_baidu_keyword 结构
CREATE TABLE IF NOT EXISTS `md_baidu_keyword` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `keyword` varchar(100) DEFAULT NULL COMMENT '关键字',
  `status` tinyint(4) DEFAULT NULL COMMENT '状态(0:暂停,1:启用,2:已存在)',
  `create_time` int(11) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `keyword` (`keyword`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 数据导出被取消选择。


-- 导出  表 mdread.md_books 结构
CREATE TABLE IF NOT EXISTS `md_books` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `book_name` varchar(255) NOT NULL COMMENT '书名',
  `book_desc` text NOT NULL COMMENT '书籍简介',
  `book_image` varchar(255) NOT NULL COMMENT '书籍图片',
  `book_author` varchar(50) NOT NULL COMMENT '书籍作者',
  `book_type` varchar(50) NOT NULL COMMENT '书籍类型',
  `book_status` varchar(50) NOT NULL COMMENT '书籍状态',
  `book_md5` char(32) NOT NULL COMMENT '根据书籍名+书籍作者(唯一性)',
  `update_time` int(11) NOT NULL COMMENT '更新时间',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `book_md5` (`book_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='书籍资源';

-- 数据导出被取消选择。


-- 导出  表 mdread.md_books_chapter 结构
CREATE TABLE IF NOT EXISTS `md_books_chapter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `book_id` int(11) DEFAULT NULL COMMENT '书籍ID',
  `source_id` int(11) DEFAULT NULL COMMENT '源ID(md_books_source ID)',
  `source_url` text COMMENT '源地址',
  `source_umd5` char(32) DEFAULT NULL,
  `chapter_name` varchar(200) DEFAULT NULL COMMENT '章节名',
  `sort` smallint(6) DEFAULT NULL COMMENT '排序',
  `create_time` int(11) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `source_umd5` (`source_umd5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='书籍章节列表';

-- 数据导出被取消选择。


-- 导出  表 mdread.md_books_click 结构
CREATE TABLE IF NOT EXISTS `md_books_click` (
  `id` int(11) DEFAULT NULL COMMENT 'ID',
  `book_id` int(11) DEFAULT NULL COMMENT '数据ID',
  `num` int(11) DEFAULT NULL COMMENT '数据',
  `create_time` int(11) DEFAULT NULL COMMENT '创建时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- 数据导出被取消选择。


-- 导出  表 mdread.md_books_soso 结构
CREATE TABLE IF NOT EXISTS `md_books_soso` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keyword` varchar(255) DEFAULT NULL,
  `num` int(11) DEFAULT '0',
  `status` varchar(255) DEFAULT NULL,
  `update_time` int(11) DEFAULT NULL,
  `create_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='搜索日志';

-- 数据导出被取消选择。


-- 导出  表 mdread.md_books_source 结构
CREATE TABLE IF NOT EXISTS `md_books_source` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `book_id` int(11) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `source_url` varchar(255) DEFAULT NULL,
  `newest_chapter` int(11) DEFAULT '0',
  `update_time` int(11) DEFAULT NULL,
  `create_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `source_url` (`source_url`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- 数据导出被取消选择。


-- 导出  表 mdread.md_cron_book 结构
CREATE TABLE IF NOT EXISTS `md_cron_book` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `source_id` int(11) DEFAULT NULL,
  `source_url` text,
  `source_umd5` char(32) DEFAULT NULL,
  `create_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `source_md5` (`source_umd5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='计划任务抓书籍地址';

-- 数据导出被取消选择。


-- 导出  表 mdread.md_cron_w 结构
CREATE TABLE IF NOT EXISTS `md_cron_w` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `w` char(50) DEFAULT NULL,
  `add_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='关键词搜索队列';

-- 数据导出被取消选择。


-- 导出  表 mdread.md_rules 结构
CREATE TABLE IF NOT EXISTS `md_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '网站名',
  `web_site` varchar(100) NOT NULL COMMENT '网站地址',
  `test_addr` varchar(100) NOT NULL,
  `rule_content` text NOT NULL COMMENT '网站搜索地址和正则',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='网站规则保存';

-- 数据导出被取消选择。
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
