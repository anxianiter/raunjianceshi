/*
 Navicat Premium Dump SQL

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 80039 (8.0.39)
 Source Host           : localhost:3306
 Source Schema         : campus_quest_pro_db

 Target Server Type    : MySQL
 Target Server Version : 80039 (8.0.39)
 File Encoding         : 65001

 Date: 23/06/2026 08:22:26
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for announcements
-- ----------------------------
DROP TABLE IF EXISTS `announcements`;
CREATE TABLE `announcements`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告内容',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active' COMMENT '状态：active启用，disabled禁用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_announcements_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '公告通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of announcements
-- ----------------------------
INSERT INTO `announcements` VALUES (1, '本周 Flask 项目验收通知', '请同学们在本周完成登录、任务领取、提交、审核和积分流水功能。', 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `announcements` VALUES (2, '今日任务盲盒已更新', '今日盲盒任务包含 Flask 入门、代码调试和课堂挑战内容。', 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `announcements` VALUES (3, '排行榜前三名展示说明', '积分排行榜前三名将在课堂上进行项目思路展示。', 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `announcements` VALUES (4, '挑战赛报名开始', '三天 Flask 入门挑战已经开放报名，欢迎同学们参与。', 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `announcements` VALUES (5, '积分商城兑换规则说明', '兑换商品会立即扣减积分，管理员处理后完成兑换。', 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');

-- ----------------------------
-- Table structure for badges
-- ----------------------------
DROP TABLE IF EXISTS `badges`;
CREATE TABLE `badges`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '徽章名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '徽章说明',
  `condition_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '条件类型',
  `condition_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '条件值',
  `reward_points` int NOT NULL DEFAULT 0 COMMENT '获得徽章奖励积分',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active' COMMENT '状态：active启用，disabled禁用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_badges_name`(`name` ASC) USING BTREE,
  INDEX `idx_badges_status`(`status` ASC) USING BTREE,
  INDEX `idx_badges_condition`(`condition_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '徽章定义表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of badges
-- ----------------------------
INSERT INTO `badges` VALUES (1, '初次登录', '第一次登录系统即可获得', 'first_login', '1', 5, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `badges` VALUES (2, '签到新手', '累计签到 3 天', 'checkin_total', '3', 5, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `badges` VALUES (3, '自律达人', '连续签到 7 天', 'continuous_checkin_days', '7', 10, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `badges` VALUES (4, '任务新星', '完成 3 个任务', 'task_approved_total', '3', 10, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `badges` VALUES (5, '任务高手', '完成 10 个任务', 'task_approved_total', '10', 20, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `badges` VALUES (6, 'Flask 初学者', '完成 Flask 入门分类下 3 个任务', 'task_category_total', 'Flask 入门|3', 15, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `badges` VALUES (7, '积分达人', '总积分达到 100', 'points_total', '100', 20, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `badges` VALUES (8, '班级之星', '进入积分排行榜前 3', 'ranking_top', '3', 20, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');

-- ----------------------------
-- Table structure for challenge_records
-- ----------------------------
DROP TABLE IF EXISTS `challenge_records`;
CREATE TABLE `challenge_records`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `challenge_id` int NOT NULL COMMENT '挑战赛ID',
  `user_id` int NOT NULL COMMENT '学生用户ID',
  `submit_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '挑战赛提交说明',
  `submit_time` datetime NULL DEFAULT NULL COMMENT '提交时间',
  `review_text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核意见',
  `review_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'joined' COMMENT '状态：joined、submitted、approved、rejected',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_challenge_user`(`challenge_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_challenge_records_status`(`status` ASC) USING BTREE,
  INDEX `fk_challenge_records_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_challenge_records_challenge` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_challenge_records_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '挑战赛报名和提交记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of challenge_records
-- ----------------------------
INSERT INTO `challenge_records` VALUES (1, 1, 2, '我完成了三天 Flask 入门挑战的第一轮练习。', '2026-05-21 14:00:00', NULL, NULL, 'submitted', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `challenge_records` VALUES (2, 1, 12, '我完成了路由、请求、响应三个练习。', '2026-05-21 13:30:00', '挑战完成度较好', '2026-05-21 14:00:00', 'approved', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `challenge_records` VALUES (3, 2, 14, '我完成了 Python 基础闯关题。', '2026-05-21 13:40:00', '通过', '2026-05-21 14:10:00', 'approved', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `challenge_records` VALUES (4, 2, 3, NULL, NULL, NULL, NULL, 'joined', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `challenge_records` VALUES (5, 3, 7, '我完成了 SQL 查询练习。', '2026-05-21 15:00:00', NULL, NULL, 'submitted', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `challenge_records` VALUES (6, 3, 8, NULL, NULL, NULL, NULL, 'joined', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `challenge_records` VALUES (7, 4, 5, NULL, NULL, NULL, NULL, 'joined', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `challenge_records` VALUES (8, 4, 17, '我修复了接口 500 报错。', '2026-05-21 15:20:00', NULL, NULL, 'submitted', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `challenge_records` VALUES (9, 5, 10, NULL, NULL, NULL, NULL, 'joined', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `challenge_records` VALUES (10, 5, 16, '我整理了三次课堂笔记。', '2026-05-21 16:00:00', NULL, NULL, 'submitted', '2026-05-22 23:35:21', '2026-05-22 23:35:21');

-- ----------------------------
-- Table structure for challenges
-- ----------------------------
DROP TABLE IF EXISTS `challenges`;
CREATE TABLE `challenges`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '挑战赛标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '挑战赛说明',
  `reward_points` int NOT NULL DEFAULT 10 COMMENT '挑战赛审核通过奖励积分',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime NOT NULL COMMENT '结束时间',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active' COMMENT '状态：active启用，disabled禁用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_challenges_status_time`(`status` ASC, `start_time` ASC, `end_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '挑战赛活动表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of challenges
-- ----------------------------
INSERT INTO `challenges` VALUES (1, '三天 Flask 入门挑战', '连续三天完成 Flask 路由、请求和响应练习。', 20, '2026-05-20 00:00:00', '2026-05-30 23:59:59', 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `challenges` VALUES (2, 'Python 基础闯关赛', '用函数、列表、字典完成一组基础闯关题。', 15, '2026-05-20 00:00:00', '2026-05-29 23:59:59', 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `challenges` VALUES (3, 'SQL 查询练习赛', '完成 5 个 SQL 查询题并说明思路。', 18, '2026-05-21 00:00:00', '2026-05-31 23:59:59', 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `challenges` VALUES (4, '代码调试挑战', '根据报错定位并修复 Flask 接口 bug。', 20, '2026-05-21 00:00:00', '2026-06-01 23:59:59', 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `challenges` VALUES (5, '课堂笔记打卡挑战', '连续整理 3 次课堂笔记并提交截图说明。', 12, '2026-05-20 00:00:00', '2026-05-28 23:59:59', 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');

-- ----------------------------
-- Table structure for checkins
-- ----------------------------
DROP TABLE IF EXISTS `checkins`;
CREATE TABLE `checkins`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` int NOT NULL COMMENT '学生用户ID',
  `checkin_date` date NOT NULL COMMENT '签到日期',
  `base_points` int NOT NULL DEFAULT 2 COMMENT '基础签到积分',
  `bonus_points` int NOT NULL DEFAULT 0 COMMENT '连续签到额外奖励积分',
  `continuous_days` int NOT NULL DEFAULT 1 COMMENT '连续签到天数',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_checkins_user_date`(`user_id` ASC, `checkin_date` ASC) USING BTREE,
  INDEX `idx_checkins_user_date`(`user_id` ASC, `checkin_date` ASC) USING BTREE,
  CONSTRAINT `fk_checkins_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '每日签到记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of checkins
-- ----------------------------
INSERT INTO `checkins` VALUES (1, 2, '2026-05-18', 2, 0, 1, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (2, 2, '2026-05-19', 2, 0, 2, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (3, 2, '2026-05-20', 2, 3, 3, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (4, 2, '2026-05-21', 2, 0, 4, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (5, 3, '2026-05-20', 2, 0, 1, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (6, 3, '2026-05-21', 2, 0, 2, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (7, 4, '2026-05-21', 2, 0, 1, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (8, 5, '2026-05-17', 2, 0, 1, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (9, 5, '2026-05-18', 2, 0, 2, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (10, 5, '2026-05-19', 2, 3, 3, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (11, 5, '2026-05-20', 2, 0, 4, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (12, 5, '2026-05-21', 2, 0, 5, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (13, 7, '2026-05-15', 2, 0, 1, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (14, 7, '2026-05-16', 2, 0, 2, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (15, 7, '2026-05-17', 2, 3, 3, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (16, 7, '2026-05-18', 2, 0, 4, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (17, 7, '2026-05-19', 2, 0, 5, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (18, 7, '2026-05-20', 2, 0, 6, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (19, 7, '2026-05-21', 2, 10, 7, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (20, 8, '2026-05-19', 2, 0, 1, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (21, 8, '2026-05-20', 2, 0, 2, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (22, 8, '2026-05-21', 2, 3, 3, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (23, 10, '2026-05-20', 2, 0, 1, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (24, 10, '2026-05-21', 2, 0, 2, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (25, 12, '2026-05-16', 2, 0, 1, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (26, 12, '2026-05-17', 2, 0, 2, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (27, 12, '2026-05-18', 2, 3, 3, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (28, 12, '2026-05-19', 2, 0, 4, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (29, 12, '2026-05-20', 2, 0, 5, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (30, 12, '2026-05-21', 2, 0, 6, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (31, 14, '2026-05-15', 2, 0, 1, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (32, 14, '2026-05-16', 2, 0, 2, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (33, 14, '2026-05-17', 2, 3, 3, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (34, 14, '2026-05-18', 2, 0, 4, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (35, 14, '2026-05-19', 2, 0, 5, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (36, 14, '2026-05-20', 2, 0, 6, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (37, 14, '2026-05-21', 2, 10, 7, '2026-05-22 23:35:21');
INSERT INTO `checkins` VALUES (38, 2, '2026-05-27', 2, 0, 1, '2026-05-27 17:31:16');

-- ----------------------------
-- Table structure for point_logs
-- ----------------------------
DROP TABLE IF EXISTS `point_logs`;
CREATE TABLE `point_logs`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` int NOT NULL COMMENT '学生用户ID',
  `related_id` int NULL DEFAULT NULL COMMENT '关联业务ID，例如任务领取ID、徽章ID或订单ID',
  `source_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源：checkin、task、badge、challenge、exchange、manual',
  `change_points` int NOT NULL COMMENT '积分变化，正数为增加，负数为扣减',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '积分变化原因',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_point_logs_user_type`(`user_id` ASC, `source_type` ASC) USING BTREE,
  INDEX `idx_point_logs_created_at`(`created_at` ASC) USING BTREE,
  CONSTRAINT `fk_point_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '积分流水表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of point_logs
-- ----------------------------
INSERT INTO `point_logs` VALUES (1, 2, 1, 'task', 5, '任务审核通过：用字典保存学生信息', '2026-05-20 11:00:00');
INSERT INTO `point_logs` VALUES (2, 2, 2, 'task', 6, '任务审核通过：Flask Hello World 路由', '2026-05-20 11:10:00');
INSERT INTO `point_logs` VALUES (3, 2, NULL, 'checkin', 2, '每日签到获得 2 积分', '2026-05-18 08:00:00');
INSERT INTO `point_logs` VALUES (4, 2, NULL, 'checkin', 2, '每日签到获得 2 积分', '2026-05-19 08:00:00');
INSERT INTO `point_logs` VALUES (5, 2, NULL, 'checkin', 5, '连续签到 3 天奖励', '2026-05-20 08:00:00');
INSERT INTO `point_logs` VALUES (6, 3, 4, 'task', 8, '任务审核通过：写一个分数等级函数', '2026-05-20 10:00:00');
INSERT INTO `point_logs` VALUES (7, 3, NULL, 'checkin', 2, '每日签到获得 2 积分', '2026-05-20 08:10:00');
INSERT INTO `point_logs` VALUES (8, 5, 7, 'task', 10, '任务审核通过：POST JSON 参数练习', '2026-05-19 10:00:00');
INSERT INTO `point_logs` VALUES (9, 5, 8, 'task', 8, '任务审核通过：jsonify 返回字典', '2026-05-20 10:00:00');
INSERT INTO `point_logs` VALUES (10, 7, 10, 'task', 10, '任务审核通过：SQLAlchemy 查询全部任务', '2026-05-18 14:30:00');
INSERT INTO `point_logs` VALUES (11, 7, 11, 'task', 10, '任务审核通过：SQLAlchemy 条件查询', '2026-05-19 14:30:00');
INSERT INTO `point_logs` VALUES (12, 7, 12, 'task', 12, '任务审核通过：分页查询练习', '2026-05-20 14:30:00');
INSERT INTO `point_logs` VALUES (13, 8, NULL, 'checkin', 5, '签到新手奖励', '2026-05-21 08:20:00');
INSERT INTO `point_logs` VALUES (14, 10, 15, 'task', 5, '任务审核通过：整理今日课堂笔记', '2026-05-20 16:30:00');
INSERT INTO `point_logs` VALUES (15, 12, 17, 'task', 6, '任务审核通过：给同学讲解函数', '2026-05-18 15:30:00');
INSERT INTO `point_logs` VALUES (16, 12, 18, 'task', 10, '任务审核通过：代码互评一次', '2026-05-19 15:30:00');
INSERT INTO `point_logs` VALUES (17, 12, 19, 'task', 12, '任务审核通过：10 分钟写登录接口', '2026-05-20 15:30:00');
INSERT INTO `point_logs` VALUES (18, 14, 21, 'task', 5, '任务审核通过：统计列表最大值', '2026-05-17 10:30:00');
INSERT INTO `point_logs` VALUES (19, 14, 22, 'task', 8, '任务审核通过：按积分排序', '2026-05-18 10:30:00');
INSERT INTO `point_logs` VALUES (20, 14, 23, 'task', 10, '任务审核通过：统计班级总积分', '2026-05-19 10:30:00');
INSERT INTO `point_logs` VALUES (21, 14, 24, 'task', 8, '任务审核通过：简单 Top3 排行', '2026-05-20 10:30:00');
INSERT INTO `point_logs` VALUES (22, 17, 28, 'task', 12, '任务审核通过：积分兑换流程图', '2026-05-20 12:00:00');
INSERT INTO `point_logs` VALUES (23, 2, 1, 'badge', 5, '获得徽章：初次登录', '2026-05-18 08:30:00');
INSERT INTO `point_logs` VALUES (24, 7, 3, 'badge', 10, '获得徽章：自律达人', '2026-05-21 08:30:00');
INSERT INTO `point_logs` VALUES (25, 14, 5, 'badge', 15, '获得徽章：任务新星', '2026-05-20 11:00:00');
INSERT INTO `point_logs` VALUES (26, 14, 7, 'badge', 20, '获得徽章：积分达人', '2026-05-21 08:40:00');
INSERT INTO `point_logs` VALUES (27, 2, 1, 'exchange', -20, '兑换商品：一次提示卡', '2026-05-21 13:00:00');
INSERT INTO `point_logs` VALUES (28, 7, 2, 'exchange', -30, '兑换商品：课堂优先展示机会', '2026-05-21 13:10:00');
INSERT INTO `point_logs` VALUES (29, 12, 1, 'challenge', 20, '挑战赛审核通过：三天 Flask 入门挑战', '2026-05-21 14:00:00');
INSERT INTO `point_logs` VALUES (30, 14, 2, 'challenge', 15, '挑战赛审核通过：Python 基础闯关赛', '2026-05-21 14:10:00');
INSERT INTO `point_logs` VALUES (31, 1, 1, 'badge', 5, '获得徽章：初次登录', '2026-05-22 23:35:57');
INSERT INTO `point_logs` VALUES (32, 2, 8, 'badge', 20, '获得徽章：班级之星', '2026-05-22 23:59:08');
INSERT INTO `point_logs` VALUES (33, 2, 7, 'badge', 20, '获得徽章：积分达人', '2026-05-27 17:31:06');
INSERT INTO `point_logs` VALUES (34, 2, NULL, 'checkin', 2, '每日签到获得 2 积分', '2026-05-27 17:31:16');

-- ----------------------------
-- Table structure for reward_orders
-- ----------------------------
DROP TABLE IF EXISTS `reward_orders`;
CREATE TABLE `reward_orders`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `reward_id` int NOT NULL COMMENT '商品ID',
  `user_id` int NOT NULL COMMENT '学生用户ID',
  `cost_points` int NOT NULL COMMENT '本次兑换扣减积分',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'created' COMMENT '状态：created、approved、rejected',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_reward_orders_user_status`(`user_id` ASC, `status` ASC) USING BTREE,
  INDEX `fk_reward_orders_reward`(`reward_id` ASC) USING BTREE,
  CONSTRAINT `fk_reward_orders_reward` FOREIGN KEY (`reward_id`) REFERENCES `rewards` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_reward_orders_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '积分兑换订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of reward_orders
-- ----------------------------
INSERT INTO `reward_orders` VALUES (1, 1, 2, 20, 'created', '2026-05-21 13:00:00', '2026-05-21 13:00:00');
INSERT INTO `reward_orders` VALUES (2, 2, 7, 30, 'approved', '2026-05-21 13:10:00', '2026-05-21 13:30:00');
INSERT INTO `reward_orders` VALUES (3, 1, 8, 20, 'created', '2026-05-21 13:15:00', '2026-05-21 13:15:00');
INSERT INTO `reward_orders` VALUES (4, 5, 14, 40, 'approved', '2026-05-21 13:20:00', '2026-05-21 13:40:00');
INSERT INTO `reward_orders` VALUES (5, 7, 12, 25, 'created', '2026-05-21 13:25:00', '2026-05-21 13:25:00');
INSERT INTO `reward_orders` VALUES (6, 6, 10, 35, 'rejected', '2026-05-21 13:30:00', '2026-05-21 13:50:00');
INSERT INTO `reward_orders` VALUES (7, 3, 17, 50, 'created', '2026-05-21 13:35:00', '2026-05-21 13:35:00');
INSERT INTO `reward_orders` VALUES (8, 1, 5, 20, 'approved', '2026-05-21 13:40:00', '2026-05-21 14:00:00');
INSERT INTO `reward_orders` VALUES (9, 2, 3, 30, 'created', '2026-05-21 13:45:00', '2026-05-21 13:45:00');
INSERT INTO `reward_orders` VALUES (10, 8, 14, 60, 'created', '2026-05-21 13:50:00', '2026-05-21 13:50:00');

-- ----------------------------
-- Table structure for rewards
-- ----------------------------
DROP TABLE IF EXISTS `rewards`;
CREATE TABLE `rewards`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品说明',
  `cost_points` int NOT NULL DEFAULT 20 COMMENT '兑换所需积分',
  `stock` int NOT NULL DEFAULT 0 COMMENT '库存数量',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active' COMMENT '状态：active上架，disabled下架',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_rewards_name`(`name` ASC) USING BTREE,
  INDEX `idx_rewards_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '积分商城商品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of rewards
-- ----------------------------
INSERT INTO `rewards` VALUES (1, '一次提示卡', '项目卡住时可向老师额外请求一次提示。', 20, 18, 'active', '2026-05-22 23:35:21', '2026-05-22 23:55:01');
INSERT INTO `rewards` VALUES (2, '课堂优先展示机会', '项目演示时获得优先展示机会。', 30, 10, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `rewards` VALUES (3, '作业延期券', '一次作业可延期一天提交。', 50, 6, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `rewards` VALUES (4, '小组加分卡', '为小组项目表现加一次展示分。', 80, 3, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `rewards` VALUES (5, '神秘称号卡', '获得一个课堂展示称号。', 40, 8, 'disabled', '2026-05-22 23:35:21', '2026-05-22 23:54:54');
INSERT INTO `rewards` VALUES (6, '免答题卡', '课堂抽问时可使用一次。', 35, 5, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `rewards` VALUES (7, '代码提示卡', '老师给出一条代码级提示。', 25, 12, 'disabled', '2026-05-22 23:35:21', '2026-05-22 23:54:51');
INSERT INTO `rewards` VALUES (8, '项目展示优先权', '期末项目优先演示。', 60, 4, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');

-- ----------------------------
-- Table structure for task_categories
-- ----------------------------
DROP TABLE IF EXISTS `task_categories`;
CREATE TABLE `task_categories`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分类说明',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_task_categories_name`(`name` ASC) USING BTREE,
  INDEX `idx_task_categories_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of task_categories
-- ----------------------------
INSERT INTO `task_categories` VALUES (1, 'Python 基础', '变量、函数、循环、条件判断等基础练习', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_categories` VALUES (2, 'Flask 入门', '路由、请求、响应、Blueprint 等 Flask 核心内容', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_categories` VALUES (3, '数据库练习', 'MySQL 与 SQLAlchemy 查询练习', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_categories` VALUES (4, '前后端交互', 'fetch、JSON、接口联调', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_categories` VALUES (5, '代码调试', '阅读报错、定位 bug、修复问题', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_categories` VALUES (6, '阅读总结', '课堂笔记、技术总结与表达', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_categories` VALUES (7, '团队互助', '给同学讲解、代码互评、协作学习', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_categories` VALUES (8, '课堂挑战', '限时完成的小挑战任务', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_categories` VALUES (9, '算法思维', '循环、列表、字典与简单算法', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_categories` VALUES (10, '项目实战', '把多个知识点串成完整业务', '2026-05-22 23:35:21', '2026-05-22 23:35:21');

-- ----------------------------
-- Table structure for task_claims
-- ----------------------------
DROP TABLE IF EXISTS `task_claims`;
CREATE TABLE `task_claims`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` int NOT NULL COMMENT '学生用户ID',
  `task_id` int NOT NULL COMMENT '任务ID',
  `claim_date` date NOT NULL COMMENT '领取日期',
  `submit_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '学生提交的打卡说明',
  `submit_time` datetime NULL DEFAULT NULL COMMENT '提交时间',
  `review_text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核意见',
  `review_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'claimed' COMMENT '状态：claimed、submitted、approved、rejected、cancelled',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_claim_user_task_date`(`user_id` ASC, `task_id` ASC, `claim_date` ASC) USING BTREE,
  INDEX `idx_claims_user_status`(`user_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_claims_task_date`(`task_id` ASC, `claim_date` ASC) USING BTREE,
  CONSTRAINT `fk_claims_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_claims_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务领取和打卡记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of task_claims
-- ----------------------------
INSERT INTO `task_claims` VALUES (1, 2, 1, '2026-05-20', '我完成了字典练习，并输出了学生信息。', '2026-05-20 10:00:00', '完成不错', '2026-05-20 11:00:00', 'approved', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (2, 2, 6, '2026-05-20', '我写好了 Flask hello world 路由。', '2026-05-20 10:20:00', '通过', '2026-05-20 11:10:00', 'approved', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (3, 2, 17, '2026-05-21', '我用 fetch 提交了登录 JSON。', '2026-05-21 09:30:00', NULL, NULL, 'submitted', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (4, 3, 2, '2026-05-20', '我写了分数等级函数并测试了多个分数。', '2026-05-20 09:00:00', '通过', '2026-05-20 10:00:00', 'approved', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (5, 3, 7, '2026-05-21', '我完成了 GET 参数练习。', '2026-05-21 10:00:00', '说明再详细一点', '2026-05-21 10:40:00', 'rejected', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (6, 4, 3, '2026-05-21', NULL, NULL, NULL, NULL, 'claimed', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (7, 5, 8, '2026-05-19', '我会使用 request.get_json 了。', '2026-05-19 09:30:00', '通过', '2026-05-19 10:00:00', 'approved', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (8, 5, 9, '2026-05-20', '我用 jsonify 返回了统一格式。', '2026-05-20 09:30:00', '通过', '2026-05-20 10:00:00', 'approved', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (9, 6, 11, '2026-05-21', NULL, NULL, NULL, NULL, 'claimed', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (10, 7, 12, '2026-05-18', '我查询了所有任务标题。', '2026-05-18 14:00:00', '通过', '2026-05-18 14:30:00', 'approved', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (11, 7, 13, '2026-05-19', '我完成了 active 条件查询。', '2026-05-19 14:00:00', '通过', '2026-05-19 14:30:00', 'approved', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (12, 7, 14, '2026-05-20', '我完成了分页查询练习。', '2026-05-20 14:00:00', '通过', '2026-05-20 14:30:00', 'approved', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (13, 8, 16, '2026-05-21', '我用 fetch 调用了 health 接口。', '2026-05-21 11:00:00', NULL, NULL, 'submitted', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (14, 9, 21, '2026-05-21', NULL, NULL, NULL, NULL, 'claimed', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (15, 10, 26, '2026-05-20', '我整理了今天的 Flask 课堂笔记。', '2026-05-20 16:00:00', '通过', '2026-05-20 16:30:00', 'approved', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (16, 11, 27, '2026-05-21', 'GET 请求通常用于查询数据。', '2026-05-21 15:00:00', NULL, NULL, 'submitted', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (17, 12, 31, '2026-05-18', '我给同学讲解了函数参数。', '2026-05-18 15:00:00', '通过', '2026-05-18 15:30:00', 'approved', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (18, 12, 32, '2026-05-19', '我完成了一次代码互评。', '2026-05-19 15:00:00', '通过', '2026-05-19 15:30:00', 'approved', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (19, 12, 36, '2026-05-20', '我限时写出了登录接口。', '2026-05-20 15:00:00', '通过', '2026-05-20 15:30:00', 'approved', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (20, 13, 38, '2026-05-21', NULL, NULL, NULL, NULL, 'claimed', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (21, 14, 41, '2026-05-17', '我找出了列表最大值。', '2026-05-17 10:00:00', '通过', '2026-05-17 10:30:00', 'approved', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (22, 14, 42, '2026-05-18', '我完成了按积分排序。', '2026-05-18 10:00:00', '通过', '2026-05-18 10:30:00', 'approved', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (23, 14, 43, '2026-05-19', '我用字典统计了班级积分。', '2026-05-19 10:00:00', '通过', '2026-05-19 10:30:00', 'approved', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (24, 14, 44, '2026-05-20', '我输出了 Top3 排行。', '2026-05-20 10:00:00', '通过', '2026-05-20 10:30:00', 'approved', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (25, 14, 45, '2026-05-21', '我使用 random.choice 模拟盲盒。', '2026-05-21 10:00:00', NULL, NULL, 'submitted', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (26, 15, 46, '2026-05-21', NULL, NULL, NULL, NULL, 'claimed', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (27, 16, 47, '2026-05-21', '我画出了任务状态流转图。', '2026-05-21 11:20:00', NULL, NULL, 'submitted', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (28, 17, 48, '2026-05-20', '我画出了积分兑换事务流程。', '2026-05-20 11:20:00', '通过', '2026-05-20 12:00:00', 'approved', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (29, 18, 49, '2026-05-21', NULL, NULL, NULL, NULL, 'claimed', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (30, 19, 50, '2026-05-21', '我根据验收表做了自查。', '2026-05-21 16:00:00', NULL, NULL, 'submitted', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `task_claims` VALUES (31, 2, 29, '2026-05-23', NULL, NULL, NULL, NULL, 'claimed', '2026-05-23 00:06:57', '2026-05-23 00:06:57');

-- ----------------------------
-- Table structure for tasks
-- ----------------------------
DROP TABLE IF EXISTS `tasks`;
CREATE TABLE `tasks`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `category_id` int NOT NULL COMMENT '任务分类ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务说明',
  `points` int NOT NULL DEFAULT 5 COMMENT '完成任务可获得积分',
  `difficulty` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'easy' COMMENT '难度：easy、normal、hard',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active' COMMENT '状态：active启用，disabled禁用',
  `is_blind_box` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否允许被任务盲盒抽中',
  `need_review` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否需要管理员审核',
  `daily_limit` int NOT NULL DEFAULT 20 COMMENT '每日最多领取次数',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tasks_category_status`(`category_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_tasks_blind_box`(`is_blind_box` ASC) USING BTREE,
  CONSTRAINT `fk_tasks_category` FOREIGN KEY (`category_id`) REFERENCES `task_categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务库表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tasks
-- ----------------------------
INSERT INTO `tasks` VALUES (1, 1, '用字典保存学生信息', '创建一个 Python 字典，保存姓名、班级、积分三个字段。', 5, 'easy', 'active', 1, 1, 30, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (2, 1, '写一个分数等级函数', '写函数 score_level(score)，返回优秀、良好、及格或待努力。', 8, 'normal', 'active', 1, 1, 25, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (3, 1, 'for 循环打印 1 到 100', '使用 for 循环输出 1 到 100，并统计偶数个数。', 5, 'easy', 'active', 1, 1, 30, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (4, 1, '列表去重小练习', '把一个含重复数字的列表去重，并说明你的思路。', 8, 'normal', 'active', 0, 1, 20, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (5, 1, '文件读取体验', '读取一个文本文件，并统计文件有多少行。', 10, 'normal', 'active', 0, 1, 20, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (6, 2, 'Flask Hello World 路由', '写一个 /hello 路由，返回 hello campus quest。', 6, 'easy', 'active', 1, 1, 30, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (7, 2, 'GET 请求参数练习', '用 request.args 获取 name 参数并返回欢迎语。', 8, 'normal', 'active', 1, 1, 30, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (8, 2, 'POST JSON 参数练习', '用 request.get_json 获取 username 和 points。', 10, 'normal', 'active', 1, 1, 25, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (9, 2, 'jsonify 返回字典', '使用 jsonify 返回 code、message、data 三个字段。', 8, 'easy', 'active', 1, 1, 30, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (10, 2, 'Blueprint 分模块', '创建一个简单 Blueprint，并注册到 app 中。', 12, 'hard', 'active', 0, 1, 15, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (11, 3, '写一个 SQL 查询语句', '查询积分大于 50 的学生姓名和积分。', 8, 'easy', 'active', 1, 1, 30, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (12, 3, 'SQLAlchemy 查询全部任务', '使用 Task.query.all 查询所有任务并打印标题。', 10, 'normal', 'active', 1, 1, 25, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (13, 3, 'SQLAlchemy 条件查询', '查询 active 状态的任务。', 10, 'normal', 'active', 1, 1, 25, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (14, 3, '分页查询练习', '使用 paginate 实现 page 和 page_size。', 12, 'hard', 'active', 0, 1, 15, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (15, 3, '外键关系解释', '画出 users、tasks、task_claims 三张表关系。', 8, 'easy', 'active', 0, 1, 20, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (16, 4, 'fetch 调用 GET 接口', '用 fetch 调用 /api/health 并打印结果。', 8, 'easy', 'active', 1, 1, 30, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (17, 4, 'fetch 发送 POST JSON', '用 fetch 登录接口发送 username 和 password。', 10, 'normal', 'active', 1, 1, 25, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (18, 4, '统一错误提示', '前端收到 code 非 200 时 alert 错误信息。', 10, 'normal', 'active', 0, 1, 20, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (19, 4, '表格渲染任务列表', '把接口返回的任务数组渲染到 table 中。', 12, 'hard', 'active', 0, 1, 15, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (20, 4, '登录后跳转首页', '登录成功后跳转 index.html。', 8, 'easy', 'active', 1, 1, 25, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (21, 5, '找出缩进错误', '阅读一段有缩进错误的 Python 代码并修复。', 5, 'easy', 'active', 1, 1, 30, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (22, 5, '定位变量名错误', '找出 NameError 的原因，并写出修复过程。', 8, 'normal', 'active', 1, 1, 25, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (23, 5, '修复数据库连接错误', '根据报错检查 .env 中的数据库配置。', 10, 'normal', 'active', 0, 1, 20, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (24, 5, '解释 404 和 500', '说明 404 与 500 的区别，并举例。', 6, 'easy', 'active', 1, 1, 30, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (25, 5, '接口返回格式排查', '检查一个接口为什么没有返回统一 JSON。', 10, 'normal', 'active', 0, 1, 20, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (26, 6, '整理今日课堂笔记', '整理今天学到的 5 个 Flask 关键词。', 5, 'easy', 'active', 1, 1, 40, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (27, 6, '解释 GET 请求', '用自己的话解释什么是 GET 请求。', 5, 'easy', 'active', 1, 1, 40, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (28, 6, '解释 POST 请求', '用自己的话解释 POST 请求适合提交什么数据。', 5, 'easy', 'active', 1, 1, 40, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (29, 6, '画出请求流程图', '画出浏览器、Flask、MySQL 的交互流程。', 8, 'normal', 'active', 1, 1, 30, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (30, 6, '总结 session 用法', '说明 session 保存了哪些登录信息。', 8, 'normal', 'active', 0, 1, 20, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (31, 7, '给同学讲解函数', '给同学讲解一个函数，并记录对方的问题。', 6, 'easy', 'active', 1, 1, 30, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (32, 7, '代码互评一次', '阅读同学的一个接口代码并提出 2 条建议。', 10, 'normal', 'active', 0, 1, 20, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (33, 7, '小组接口联调', '两人一组完成一个前端 fetch 联调。', 12, 'hard', 'active', 0, 1, 15, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (34, 7, '帮助同学排错', '帮助同学解决一个报错，并记录解决过程。', 8, 'normal', 'active', 1, 1, 25, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (35, 7, '讲清一个数据库字段', '说明 status 字段为什么常用于业务状态控制。', 8, 'normal', 'active', 0, 1, 20, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (36, 8, '10 分钟写登录接口', '限时写出登录接口的参数接收与返回。', 12, 'hard', 'active', 1, 1, 10, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (37, 8, '15 分钟写列表查询', '限时完成一个简单列表接口。', 12, 'hard', 'active', 1, 1, 10, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (38, 8, '快速写新增分类', '完成新增分类接口并测试。', 10, 'normal', 'active', 1, 1, 20, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (39, 8, '快速写状态切换', '完成启用禁用接口的核心代码。', 10, 'normal', 'active', 1, 1, 20, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (40, 8, '统一响应挑战', '把一个普通字典返回改成 success_response。', 8, 'easy', 'active', 1, 1, 25, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (41, 9, '统计列表最大值', '找出列表中最大的积分。', 5, 'easy', 'active', 1, 1, 30, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (42, 9, '按积分排序', '将学生字典列表按 points 倒序排序。', 8, 'normal', 'active', 1, 1, 25, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (43, 9, '统计班级总积分', '用字典统计每个班级总积分。', 10, 'normal', 'active', 1, 1, 20, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (44, 9, '简单 Top3 排行', '输出积分前三名学生。', 8, 'normal', 'active', 1, 1, 25, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (45, 9, '随机抽取任务', '用 random.choice 模拟任务盲盒。', 8, 'normal', 'active', 1, 1, 25, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (46, 10, '设计统一返回格式', '给一个接口设计 code、message、data 返回格式。', 8, 'easy', 'active', 0, 1, 20, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (47, 10, '任务状态流转图', '画出 claimed 到 approved 的状态流转。', 10, 'normal', 'active', 0, 1, 20, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (48, 10, '积分兑换流程图', '画出积分商城兑换的事务流程。', 12, 'hard', 'active', 0, 1, 15, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (49, 10, '项目演示脚本', '写一段 3 分钟项目演示讲稿。', 8, 'normal', 'active', 0, 1, 20, '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `tasks` VALUES (50, 10, '项目验收自查', '根据验收表检查自己完成了哪些功能。', 10, 'normal', 'active', 0, 1, 20, '2026-05-22 23:35:21', '2026-05-22 23:35:21');

-- ----------------------------
-- Table structure for user_badges
-- ----------------------------
DROP TABLE IF EXISTS `user_badges`;
CREATE TABLE `user_badges`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` int NOT NULL COMMENT '学生用户ID',
  `badge_id` int NOT NULL COMMENT '徽章ID',
  `awarded_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '获得时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_badges_user_badge`(`user_id` ASC, `badge_id` ASC) USING BTREE,
  INDEX `idx_user_badges_user`(`user_id` ASC) USING BTREE,
  INDEX `fk_user_badges_badge`(`badge_id` ASC) USING BTREE,
  CONSTRAINT `fk_user_badges_badge` FOREIGN KEY (`badge_id`) REFERENCES `badges` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_user_badges_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户徽章表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_badges
-- ----------------------------
INSERT INTO `user_badges` VALUES (1, 2, 1, '2026-05-18 08:30:00');
INSERT INTO `user_badges` VALUES (2, 2, 2, '2026-05-20 08:30:00');
INSERT INTO `user_badges` VALUES (3, 5, 1, '2026-05-17 08:30:00');
INSERT INTO `user_badges` VALUES (4, 5, 2, '2026-05-19 08:30:00');
INSERT INTO `user_badges` VALUES (5, 7, 1, '2026-05-15 08:30:00');
INSERT INTO `user_badges` VALUES (6, 7, 2, '2026-05-17 08:30:00');
INSERT INTO `user_badges` VALUES (7, 7, 3, '2026-05-21 08:30:00');
INSERT INTO `user_badges` VALUES (8, 12, 1, '2026-05-16 08:30:00');
INSERT INTO `user_badges` VALUES (9, 12, 4, '2026-05-20 16:00:00');
INSERT INTO `user_badges` VALUES (10, 14, 1, '2026-05-15 08:30:00');
INSERT INTO `user_badges` VALUES (11, 14, 2, '2026-05-17 08:30:00');
INSERT INTO `user_badges` VALUES (12, 14, 3, '2026-05-21 08:30:00');
INSERT INTO `user_badges` VALUES (13, 14, 7, '2026-05-21 08:40:00');
INSERT INTO `user_badges` VALUES (14, 1, 1, '2026-05-22 23:35:57');
INSERT INTO `user_badges` VALUES (15, 2, 8, '2026-05-22 23:59:08');
INSERT INTO `user_badges` VALUES (16, 2, 7, '2026-05-27 17:31:06');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '登录用户名',
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Werkzeug生成的密码哈希',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'student' COMMENT '角色：admin管理员，student学生',
  `student_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学生学号，管理员为空',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名或昵称',
  `class_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '班级名称',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像访问路径，例如 /static/uploads/avatars/avatar_xxx.png',
  `points` int NOT NULL DEFAULT 0 COMMENT '当前总积分',
  `continuous_checkin_days` int NOT NULL DEFAULT 0 COMMENT '连续签到天数',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active' COMMENT '账号状态：active启用，disabled禁用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_users_username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `uk_users_student_no`(`student_no` ASC) USING BTREE,
  INDEX `idx_users_role_status`(`role` ASC, `status` ASC) USING BTREE,
  INDEX `idx_users_class_name`(`class_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表：管理员和学生共用' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'admin', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'admin', NULL, '系统管理员', NULL, '13800000000', '/static/uploads/avatars/avatar_1_9485d78c16344aa48cd914f0f1e8139a.jpg', 5, 0, 'active', '2026-05-22 23:35:21', '2026-05-28 17:27:32');
INSERT INTO `users` VALUES (2, 'stu001', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026001', '林小航', 'Python一班', '13900000001', '/static/uploads/avatars/avatar_2_44577d93316f47a79539ec95f4d1601e.jpg', 138, 1, 'active', '2026-05-22 23:35:21', '2026-05-28 17:26:39');
INSERT INTO `users` VALUES (3, 'stu002', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026002', '周晴', 'Python一班', '13900000002', NULL, 88, 2, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `users` VALUES (4, 'stu003', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026003', '陈然', 'Python一班', '13900000003', NULL, 75, 1, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `users` VALUES (5, 'stu004', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026004', '赵越', 'Python一班', '13900000004', NULL, 66, 5, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `users` VALUES (6, 'stu005', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026005', '何安', 'Python一班', '13900000005', NULL, 42, 0, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `users` VALUES (7, 'stu006', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026006', '王可', 'Python二班', '13900000006', NULL, 101, 7, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `users` VALUES (8, 'stu007', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026007', '宋雨', 'Python二班', '13900000007', NULL, 59, 3, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `users` VALUES (9, 'stu008', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026008', '李牧', 'Python二班', '13900000008', NULL, 37, 0, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `users` VALUES (10, 'stu009', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026009', '唐夏', 'Python二班', '13900000009', NULL, 72, 2, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `users` VALUES (11, 'stu010', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026010', '许诺', 'Python二班', '13900000010', NULL, 53, 1, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `users` VALUES (12, 'stu011', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026011', '韩晨', 'Flask一班', '13900000011', NULL, 89, 6, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `users` VALUES (13, 'stu012', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026012', '吴双', 'Flask一班', '13900000012', NULL, 48, 0, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `users` VALUES (14, 'stu013', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026013', '郑一', 'Flask一班', '13900000013', NULL, 120, 7, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `users` VALUES (15, 'stu014', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026014', '秦川', 'Flask一班', '13900000014', NULL, 23, 1, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `users` VALUES (16, 'stu015', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026015', '罗星', 'Flask一班', '13900000015', NULL, 61, 2, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `users` VALUES (17, 'stu016', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026016', '叶青', '项目实战班', '13900000016', NULL, 80, 4, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `users` VALUES (18, 'stu017', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026017', '马远', '项目实战班', '13900000017', NULL, 34, 0, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `users` VALUES (19, 'stu018', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026018', '高扬', '项目实战班', '13900000018', NULL, 55, 3, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `users` VALUES (20, 'stu019', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026019', '施宁', '项目实战班', '13900000019', NULL, 44, 1, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');
INSERT INTO `users` VALUES (21, 'stu020', 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b', 'student', 'S2026020', '孟舟', '项目实战班', '13900000020', NULL, 69, 2, 'active', '2026-05-22 23:35:21', '2026-05-22 23:35:21');

SET FOREIGN_KEY_CHECKS = 1;
