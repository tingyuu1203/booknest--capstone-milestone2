/*
 Navicat Premium Data Transfer

 Source Server         : 192.168.198.128
 Source Server Type    : MySQL
 Source Server Version : 80032
 Source Host           : 192.168.198.128:3306
 Source Schema         : webapp

 Target Server Type    : MySQL
 Target Server Version : 80032
 File Encoding         : 65001

 Date: 27/07/2025 22:06:43
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for books
-- ----------------------------
DROP TABLE IF EXISTS `books`;
CREATE TABLE `books`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `author` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `stock` int UNSIGNED NOT NULL DEFAULT 0,
  `cover_image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of books
-- ----------------------------
INSERT INTO `books` VALUES (1, 'Python 编程', '张三', 'Python 入门教程', 13, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGuZ0mDCP3I9AftJmiC5t8A3xxCoMGZRicNQ&s', '2025-07-25 09:00:53', '2025-07-26 10:56:30');
INSERT INTO `books` VALUES (3, '挺好听任何', '3434', '规划法规和', 343, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGuZ0mDCP3I9AftJmiC5t8A3xxCoMGZRicNQ&s', '2025-07-26 10:28:55', '2025-07-26 10:28:55');

-- ----------------------------
-- Table structure for borrow_records
-- ----------------------------
DROP TABLE IF EXISTS `borrow_records`;
CREATE TABLE `borrow_records`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `book_id` int NOT NULL,
  `borrow_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `return_date` timestamp NULL DEFAULT NULL,
  `status` enum('borrowed','returned','requested','denied') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'requested',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `book_id`(`book_id` ASC) USING BTREE,
  CONSTRAINT `borrow_records_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `borrow_records_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of borrow_records
-- ----------------------------
INSERT INTO `borrow_records` VALUES (1, 3, 1, '2025-07-25 09:02:12', NULL, 'denied');
INSERT INTO `borrow_records` VALUES (2, 3, 1, '2025-07-26 09:39:36', '2025-07-26 10:05:53', 'returned');
INSERT INTO `borrow_records` VALUES (3, 3, 3, '2025-07-26 11:00:10', NULL, 'requested');
INSERT INTO `borrow_records` VALUES (4, 3, 3, '2025-07-31 00:00:00', NULL, 'requested');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `role` enum('user','admin') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'user',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (3, '测试用户', 'test@ex.com', '123456', 'user', '2025-07-25 08:53:52');
INSERT INTO `users` VALUES (4, 'admin', 'admin@ex.com', '123456', 'admin', '2025-07-26 09:12:57');
INSERT INTO `users` VALUES (5, 'testuser', 'test@example.com', '123456', 'user', '2025-07-26 12:25:08');

SET FOREIGN_KEY_CHECKS = 1;
