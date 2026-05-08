-- TCTF MySQL 数据库初始化脚本
-- 使用方法: mysql -uroot -p123456 < init.sql

-- 删除旧数据库（如果需要完全重建）
DROP DATABASE IF EXISTS tctf;

-- 创建数据库
CREATE DATABASE tctf DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE tctf;

-- 用户表
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    score INT DEFAULT 0,
    is_admin INT DEFAULT 0,
    is_creator INT DEFAULT 0,
    avatar VARCHAR(255) DEFAULT 'default.png',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 题目表
CREATE TABLE IF NOT EXISTS challenges (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(50) NOT NULL,
    flag VARCHAR(255) NOT NULL,
    points INT NOT NULL,
    file_path VARCHAR(255),
    enable_dynamic_host INT DEFAULT 0,
    docker_image VARCHAR(255),
    is_active INT DEFAULT 1,
    creator_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 解题记录表
CREATE TABLE IF NOT EXISTS solves (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    challenge_id INT NOT NULL,
    solved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (challenge_id) REFERENCES challenges(id),
    UNIQUE KEY unique_user_challenge (user_id, challenge_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 写入提示表
CREATE TABLE IF NOT EXISTS hints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    challenge_id INT NOT NULL,
    hint_text TEXT NOT NULL,
    cost INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (challenge_id) REFERENCES challenges(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 动态主机表
CREATE TABLE IF NOT EXISTS dynamic_hosts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    challenge_id INT NOT NULL,
    user_id INT,
    container_name VARCHAR(255) NOT NULL,
    container_id VARCHAR(255) NOT NULL,
    port INT NOT NULL,
    host_url VARCHAR(255) NOT NULL,
    status VARCHAR(50) DEFAULT 'running',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NULL,
    FOREIGN KEY (challenge_id) REFERENCES challenges(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 分类表
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 系统配置表
CREATE TABLE IF NOT EXISTS system_config (
    id INT AUTO_INCREMENT PRIMARY KEY,
    config_key VARCHAR(100) UNIQUE NOT NULL,
    config_value TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 竞赛表
CREATE TABLE IF NOT EXISTS competitions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    announcement TEXT,
    start_time VARCHAR(100),
    end_time VARCHAR(100),
    is_active INT DEFAULT 1,
    enable_theory INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 竞赛题目关联表
CREATE TABLE IF NOT EXISTS competition_challenges (
    id INT AUTO_INCREMENT PRIMARY KEY,
    competition_id INT NOT NULL,
    challenge_id INT NOT NULL,
    FOREIGN KEY (competition_id) REFERENCES competitions(id),
    FOREIGN KEY (challenge_id) REFERENCES challenges(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 竞赛分类关联表
CREATE TABLE IF NOT EXISTS competition_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    competition_id INT NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (competition_id) REFERENCES competitions(id),
    FOREIGN KEY (category_id) REFERENCES categories(id),
    UNIQUE KEY unique_comp_cat (competition_id, category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 竞赛报名表
CREATE TABLE IF NOT EXISTS competition_registrations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    competition_id INT NOT NULL,
    user_id INT NOT NULL,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (competition_id) REFERENCES competitions(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    UNIQUE KEY unique_comp_user (competition_id, user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 理论题表
-- competition_id = 0 表示题库中的题目（不会关联到任何竞赛）
CREATE TABLE IF NOT EXISTS theory_questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    competition_id INT NOT NULL DEFAULT 0,
    question TEXT NOT NULL,
    options JSON NOT NULL,
    answer INT NOT NULL,
    points INT DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_competition_id (competition_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 理论题答题记录表
CREATE TABLE IF NOT EXISTS theory_submissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    competition_id INT NOT NULL,
    user_id INT NOT NULL,
    score INT NOT NULL,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (competition_id) REFERENCES competitions(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    UNIQUE KEY unique_comp_user_submission (competition_id, user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 讨论区表
CREATE TABLE IF NOT EXISTS discussions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    author_id INT NOT NULL,
    challenge_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES users(id),
    FOREIGN KEY (challenge_id) REFERENCES challenges(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 回复表
CREATE TABLE IF NOT EXISTS replies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    discussion_id INT NOT NULL,
    content TEXT NOT NULL,
    author_id INT NOT NULL,
    parent_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (discussion_id) REFERENCES discussions(id),
    FOREIGN KEY (author_id) REFERENCES users(id),
    FOREIGN KEY (parent_id) REFERENCES replies(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 插入默认管理员账户 (用户名: admin, 密码: admin123)
-- 管理员将在应用启动时由 create_default_admin() 函数自动创建（使用正确的密码哈希）
-- 为避免重复，这里只插入标记，由应用层处理管理员创建

-- 插入默认网站标题配置
INSERT INTO system_config (config_key, config_value) VALUES 
('site_title', 'TCTF');

-- 完成
SELECT 'Database initialization completed successfully!' AS message;
