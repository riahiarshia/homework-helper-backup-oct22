-- Sample data for staging database testing

-- Insert sample users
INSERT INTO users (email, password_hash, apple_user_id, subscription_status, subscription_expires_at) VALUES
('test@example.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'apple123', 'premium', '2025-12-31 23:59:59'),
('user2@example.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'apple456', 'trial', '2025-11-30 23:59:59'),
('user3@example.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'apple789', 'premium', '2025-12-31 23:59:59')
ON CONFLICT (email) DO NOTHING;

-- Insert sample homework submissions
INSERT INTO homework_submissions (user_id, image_url, analysis_result) VALUES
(1, 'https://example.com/image1.jpg', 'Math problem solved: 2x + 3 = 7, x = 2'),
(1, 'https://example.com/image2.jpg', 'Science question answered: Photosynthesis process'),
(2, 'https://example.com/image3.jpg', 'History essay about World War II'),
(3, 'https://example.com/image4.jpg', 'Physics calculation: F = ma')
ON CONFLICT DO NOTHING;

-- Insert sample usage tracking
INSERT INTO usage_tracking (user_id, action, details) VALUES
(1, 'homework_analysis', '{"subject": "math", "difficulty": "medium"}'),
(1, 'homework_analysis', '{"subject": "science", "difficulty": "easy"}'),
(2, 'homework_analysis', '{"subject": "history", "difficulty": "hard"}'),
(3, 'homework_analysis', '{"subject": "physics", "difficulty": "hard"}')
ON CONFLICT DO NOTHING;

-- Insert sample monthly usage
INSERT INTO monthly_usage (user_id, month, year, usage_count) VALUES
(1, 10, 2025, 15),
(2, 10, 2025, 8),
(3, 10, 2025, 12)
ON CONFLICT (user_id, month, year) DO NOTHING;

-- Insert sample device tracking
INSERT INTO device_tracking (user_id, device_id, device_info) VALUES
(1, 'device123', '{"model": "iPhone 14", "os": "iOS 17.0"}'),
(2, 'device456', '{"model": "iPad Pro", "os": "iOS 17.1"}'),
(3, 'device789', '{"model": "iPhone 15", "os": "iOS 17.2"}')
ON CONFLICT DO NOTHING;

-- Insert sample entitlements ledger
INSERT INTO entitlements_ledger (user_id, action, amount, balance, details) VALUES
(1, 'subscription_purchase', 100, 100, '{"plan": "premium", "duration": "monthly"}'),
(2, 'trial_start', 10, 10, '{"plan": "trial", "duration": "7_days"}'),
(3, 'subscription_purchase', 100, 100, '{"plan": "premium", "duration": "monthly"}')
ON CONFLICT DO NOTHING;

-- Insert sample subscription data
INSERT INTO subscription_data (user_id, subscription_id, status, plan, expires_at) VALUES
(1, 'sub_123', 'active', 'premium', '2025-12-31 23:59:59'),
(2, 'sub_456', 'trial', 'trial', '2025-11-30 23:59:59'),
(3, 'sub_789', 'active', 'premium', '2025-12-31 23:59:59')
ON CONFLICT DO NOTHING;

-- Show summary
SELECT 'Sample data inserted successfully!' as message;
SELECT 'Users:' as table_name, COUNT(*) as count FROM users;
SELECT 'Homework Submissions:' as table_name, COUNT(*) as count FROM homework_submissions;
SELECT 'Usage Tracking:' as table_name, COUNT(*) as count FROM usage_tracking;
SELECT 'Monthly Usage:' as table_name, COUNT(*) as count FROM monthly_usage;
SELECT 'Device Tracking:' as table_name, COUNT(*) as count FROM device_tracking;
SELECT 'Entitlements Ledger:' as table_name, COUNT(*) as count FROM entitlements_ledger;
SELECT 'Subscription Data:' as table_name, COUNT(*) as count FROM subscription_data;
