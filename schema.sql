CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO roles (role_name) VALUES
('Admin'),
('Editor'),
('Journalist'),
('Reader');

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role_id INT REFERENCES roles(role_id),
    status VARCHAR(20) DEFAULT 'active'
        CHECK (status IN ('active','blocked')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (full_name, email, password_hash, role_id) VALUES
('Admin User', 'admin@mail.com', '123', 1),
('Editor User', 'editor@mail.com', '123', 2),
('Journalist User', 'journalist@mail.com', '123', 3),
('Reader User', 'reader@mail.com', '123', 4);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

INSERT INTO categories (category_name, description) VALUES
('Саясат', 'Саяси жаңалықтар'),
('Экономика', 'Экономикалық жаңалықтар'),
('Спорт', 'Спорт жаңалықтары'),
('Технология', 'IT және технология жаңалықтары');

CREATE TABLE articles (
    article_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    publish_date TIMESTAMP,
    author_id INT REFERENCES users(user_id),
    category_id INT REFERENCES categories(category_id),
    status VARCHAR(20) DEFAULT 'Draft'
        CHECK (status IN ('Draft','Published','Rejected')),
    views_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO articles (title, content, publish_date, author_id, category_id, status, views_count)
VALUES
('Жаңа заң қабылданды', 'Парламент жаңа заң қабылдады...', NOW(), 3, 1, 'Published', 150),
('Экономикалық өсім 5%', 'Биылғы өсім 5% болды...', NOW(), 3, 2, 'Published', 200),
('Футбол матчы', 'Қазақстан құрамасы жеңіске жетті...', NOW(), 3, 3, 'Draft', 50),
('Жаңа AI технологиясы', 'Жаңа жасанды интеллект жүйесі таныстырылды...', NOW(), 3, 4, 'Published', 320);

CREATE TABLE comments (
    comment_id SERIAL PRIMARY KEY,
    article_id INT REFERENCES articles(article_id) ON DELETE CASCADE,
    user_id INT REFERENCES users(user_id),
    comment_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO comments (article_id, user_id, comment_text) VALUES
(1, 4, 'Өте маңызды жаңалық!'),
(2, 4, 'Қызықты ақпарат.'),
(4, 4, 'AI болашағы зор!');

CREATE TABLE tags (
    tag_id SERIAL PRIMARY KEY,
    tag_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE article_tags (
    article_id INT REFERENCES articles(article_id) ON DELETE CASCADE,
    tag_id INT REFERENCES tags(tag_id) ON DELETE CASCADE,
    PRIMARY KEY(article_id, tag_id)
);

INSERT INTO tags (tag_name) VALUES
('Маңызды'),
('2025'),
('Актуалды'),
('AI');

INSERT INTO article_tags VALUES
(1,1),
(1,2),
(2,3),
(4,4);

CREATE TABLE likes (
    like_id SERIAL PRIMARY KEY,
    article_id INT REFERENCES articles(article_id),
    user_id INT REFERENCES users(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(article_id, user_id)
);

INSERT INTO likes (article_id, user_id) VALUES
(1,4),
(2,4),
(4,4);

CREATE TABLE views (
    view_id SERIAL PRIMARY KEY,
    article_id INT REFERENCES articles(article_id),
    user_id INT REFERENCES users(user_id),
    ip_address VARCHAR(50),
    viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO views (article_id, user_id, ip_address) VALUES
(1,4,'192.168.0.1'),
(1,4,'192.168.0.2'),
(2,4,'192.168.0.3'),
(4,4,'192.168.0.4');

CREATE INDEX idx_articles_author ON articles(author_id);
CREATE INDEX idx_articles_category ON articles(category_id);
CREATE INDEX idx_articles_status ON articles(status);
CREATE INDEX idx_comments_article ON comments(article_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_likes_article ON likes(article_id);

SELECT a.title, u.full_name, c.category_name
FROM articles a
JOIN users u ON a.author_id = u.user_id
JOIN categories c ON a.category_id = c.category_id;

SELECT author_id, COUNT(*) AS total_articles
FROM articles
GROUP BY author_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS total_articles,
       AVG(views_count) AS avg_views
FROM articles;

SELECT *
FROM articles
WHERE status = 'Published'
AND views_count > 100;

EXPLAIN ANALYZE
SELECT * FROM articles WHERE author_id = 3;
