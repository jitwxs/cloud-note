/*
Navicat MySQL Data Transfer

Source Server         : local
Source Server Version : 50719
Source Host           : localhost:3306
Source Database       : cloud_note

Target Server Type    : MYSQL
Target Server Version : 50719
File Encoding         : 65001

Date: 2018-01-03 14:43:47
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article` (
  `id` varchar(64) NOT NULL,
  `title` varchar(32) NOT NULL COMMENT '文章标题',
  `content` varchar(255) DEFAULT NULL COMMENT '文章内容',
  `user_id` varchar(64) NOT NULL COMMENT '作者id',
  `dir_id` varchar(64) NOT NULL COMMENT '所属文件夹id',
  `create_date` datetime NOT NULL,
  `modifed_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_user` (`user_id`),
  KEY `fk_dir` (`dir_id`),
  CONSTRAINT `fk_dir` FOREIGN KEY (`dir_id`) REFERENCES `directory` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of article
-- ----------------------------

-- ----------------------------
-- Table structure for article_tag
-- ----------------------------
DROP TABLE IF EXISTS `article_tag`;
CREATE TABLE `article_tag` (
  `article_id` varchar(64) NOT NULL,
  `tag_id` varchar(64) NOT NULL,
  PRIMARY KEY (`article_id`,`tag_id`),
  KEY `fk_tag` (`tag_id`),
  CONSTRAINT `fk_article` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_tag` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of article_tag
-- ----------------------------

-- ----------------------------
-- Table structure for directory
-- ----------------------------
DROP TABLE IF EXISTS `directory`;
CREATE TABLE `directory` (
  `id` varchar(64) NOT NULL,
  `name` varchar(32) NOT NULL COMMENT '目录名称',
  `parent_id` varchar(64) DEFAULT NULL COMMENT '父目录id',
  `create_date` datetime NOT NULL,
  `modifed_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_parent` (`parent_id`),
  CONSTRAINT `fk_parent` FOREIGN KEY (`parent_id`) REFERENCES `directory` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of directory
-- ----------------------------
INSERT INTO `directory` VALUES ('a9eff09ae43b476996cff193c9ca04c3', '我的文件夹', null, '2018-01-03 10:07:17', null);

-- ----------------------------
-- Table structure for login
-- ----------------------------
DROP TABLE IF EXISTS `login`;
CREATE TABLE `login` (
  `tel` varchar(16) NOT NULL COMMENT '手机号',
  `password` varchar(64) NOT NULL COMMENT '密码',
  `role_id` int(10) unsigned NOT NULL COMMENT '用户权限',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `modified_date` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`tel`),
  KEY `fk_role` (`role_id`),
  CONSTRAINT `fk_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of login
-- ----------------------------
INSERT INTO `login` VALUES ('18168404321', '8a423f131115c0026c7617b1ef3fd238b409d049ade27fa9d0e6136a', '2', '2018-01-03 13:07:11', null);
INSERT INTO `login` VALUES ('18168404329', '8eb6030a2cf40d7a0dd92d88513621b61b86aeb5c16a0b841ef39b97', '2', '2018-01-03 12:57:52', null);

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` int(10) unsigned NOT NULL COMMENT '权限id',
  `name` varchar(32) NOT NULL COMMENT '权限名称',
  `create_time` datetime NOT NULL,
  `modified_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('1', 'admin', '2018-01-02 22:24:26', null);
INSERT INTO `role` VALUES ('2', 'user', '2018-01-02 22:24:36', null);

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
  `id` varchar(64) NOT NULL,
  `name` varchar(32) DEFAULT NULL COMMENT '标签名称',
  `create_date` datetime NOT NULL,
  `modifed_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tag
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` varchar(64) NOT NULL,
  `tel` varchar(16) NOT NULL,
  `name` varchar(16) DEFAULT NULL COMMENT '昵称',
  `email` varchar(32) DEFAULT NULL COMMENT '邮箱',
  `area` varchar(32) DEFAULT NULL COMMENT '地区',
  `icon` varchar(32) DEFAULT NULL COMMENT '头像',
  `sex` tinyint(1) DEFAULT NULL COMMENT '性别（1：男；0：女）',
  `sign` varchar(32) DEFAULT NULL COMMENT '签名',
  `create_date` datetime NOT NULL,
  `modifed_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_tel` (`tel`),
  CONSTRAINT `fk_tel` FOREIGN KEY (`tel`) REFERENCES `login` (`tel`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('694303fe17df43ad9dfdf3e75688fe32', '18168404329', null, null, null, null, null, null, '2018-01-03 12:57:52', null);
INSERT INTO `user` VALUES ('7963cdd80c3b4144b75003e1dd611494', '18168404321', null, null, null, null, null, null, '2018-01-03 13:07:11', null);
