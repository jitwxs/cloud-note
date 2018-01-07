/*
Navicat MySQL Data Transfer

Source Server         : local
Source Server Version : 50719
Source Host           : localhost:3306
Source Database       : cloud_note

Target Server Type    : MYSQL
Target Server Version : 50719
File Encoding         : 65001

Date: 2018-01-07 09:59:24
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
  `is_open` int(11) NOT NULL DEFAULT '0' COMMENT '是否公开（1：公开；0：不公开）',
  `share_url` varchar(64) DEFAULT NULL COMMENT '分享url',
  `create_date` datetime NOT NULL,
  `modifed_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_user` (`user_id`),
  KEY `fk_dir` (`dir_id`),
  CONSTRAINT `fk_dir` FOREIGN KEY (`dir_id`) REFERENCES `directory` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of article
-- ----------------------------
INSERT INTO `article` VALUES ('4dc3fb11206d4a4aa6f2462209873c83', 'aa', null, '05d4849d43704410a904f93632e9f9b0', 'root', '0', null, '2018-01-07 09:47:52', '2018-01-07 09:48:10');
INSERT INTO `article` VALUES ('969875103db5474d9aff3b260e1d18d7', 'nnn', null, '05d4849d43704410a904f93632e9f9b0', '1bb210c49aab46e087c31fc0d76ca423', '0', null, '2018-01-07 09:46:43', null);
INSERT INTO `article` VALUES ('d0dea94079384f18b685f7750b99a946', 'xxx', null, '05d4849d43704410a904f93632e9f9b0', '1bb210c49aab46e087c31fc0d76ca423', '0', null, '2018-01-07 09:47:34', null);

-- ----------------------------
-- Table structure for article_recycle
-- ----------------------------
DROP TABLE IF EXISTS `article_recycle`;
CREATE TABLE `article_recycle` (
  `id` varchar(64) NOT NULL,
  `title` varchar(32) NOT NULL COMMENT '文章标题',
  `content` varchar(255) DEFAULT NULL COMMENT '文章内容',
  `user_id` varchar(64) NOT NULL COMMENT '作者id',
  `dir_id` varchar(64) NOT NULL COMMENT '所属文件夹id',
  `is_open` int(11) NOT NULL DEFAULT '0' COMMENT '是否公开（1：公开；0：不公开）',
  `share_url` varchar(64) DEFAULT NULL COMMENT '分享url',
  `create_date` datetime NOT NULL,
  `modifed_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_user` (`user_id`),
  KEY `fk_dir` (`dir_id`),
  CONSTRAINT `article_recycle_ibfk_1` FOREIGN KEY (`dir_id`) REFERENCES `directory` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `article_recycle_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of article_recycle
-- ----------------------------
INSERT INTO `article_recycle` VALUES ('a7f26d46cb24495a99d26f0133d7f78e', 'a\'g\'fa', null, '05d4849d43704410a904f93632e9f9b0', 'root', '0', null, '2018-01-06 17:58:11', null);
INSERT INTO `article_recycle` VALUES ('b45ac2345a9f44ba8d4bcc8b90b42839', 'bbb', null, '05d4849d43704410a904f93632e9f9b0', 'root', '0', null, '2018-01-07 09:43:54', '2018-01-06 19:06:44');
INSERT INTO `article_recycle` VALUES ('c12d55273622487985f9adeef94a2fbc', 'aaa', null, '05d4849d43704410a904f93632e9f9b0', 'root', '0', null, '2018-01-07 09:43:55', '2018-01-06 19:06:44');

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
  `uid` varchar(64) DEFAULT NULL,
  `name` varchar(32) NOT NULL COMMENT '目录名称',
  `parent_id` varchar(64) DEFAULT NULL COMMENT '父目录id',
  `create_date` datetime NOT NULL,
  `modifed_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_uid` (`uid`),
  KEY `fk_parent` (`parent_id`),
  CONSTRAINT `fk_parent` FOREIGN KEY (`parent_id`) REFERENCES `directory` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_uid` FOREIGN KEY (`uid`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of directory
-- ----------------------------
INSERT INTO `directory` VALUES ('1bb210c49aab46e087c31fc0d76ca423', '05d4849d43704410a904f93632e9f9b0', 'xxx', 'root', '2018-01-07 09:43:58', null);
INSERT INTO `directory` VALUES ('root', null, '我的文件夹', null, '2018-01-06 16:43:53', null);

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
INSERT INTO `login` VALUES ('18168404321', 'f4b9b2efb4a26a6319fc66021695358d7e093cba4b8315b27542163d', '1', '2018-01-04 00:19:56', null);
INSERT INTO `login` VALUES ('18168404326', '0a436092af3acc486004d93e08f7eb01ac7d6675ab412954299f3e49', '2', '2018-01-05 11:30:16', null);
INSERT INTO `login` VALUES ('18168404329', 'ed29ad7b200cdfa18fd39b4d2b013c92c5aebb10b8121f762ff99161', '2', '2018-01-04 00:23:38', '2018-01-07 09:36:51');

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
  `icon` varchar(128) DEFAULT NULL COMMENT '头像',
  `sex` char(1) DEFAULT NULL COMMENT '性别',
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
INSERT INTO `user` VALUES ('05d4849d43704410a904f93632e9f9b0', '18168404329', 'jitwxs', 'jitwxs@foxmail.com', '南京', '18168404329/18168404329.jpg', '男', '', '2018-01-04 00:23:38', '2018-01-07 09:48:43');
INSERT INTO `user` VALUES ('733900ac3a764099b0410844b0b33aae', '18168404326', null, null, null, null, null, null, '2018-01-05 11:30:16', null);
INSERT INTO `user` VALUES ('fda14630bb884e5d8a038a067f7af463', '18168404321', '', '', '', '18168404321/18168404321.jpg', '男', '', '2018-01-04 00:19:56', '2018-01-06 15:11:32');
