-- Insert demo user
INSERT INTO users (name, email) VALUES 
  ('John Smith', 'john@example.com')
ON CONFLICT (email) DO NOTHING;

-- Insert accounts for the demo user
INSERT INTO accounts (user_id, account_type, balance) VALUES
  (1, 'Checking', 8512.72),
  (1, 'Savings', 11506.04)
ON CONFLICT DO NOTHING;

-- Insert transactions for checking account
INSERT INTO transactions (account_id, type, amount, description) VALUES
  (1, 'deposit', 2000.00, 'Direct deposit - salary'),
  (1, 'withdrawal', 150.00, 'ATM withdrawal'),
  (1, 'purchase', 89.99, 'Amazon purchase'),
  (1, 'withdrawal', 50.00, 'Gas station'),
  (1, 'purchase', 245.50, 'Restaurant'),
  (1, 'purchase', 12.99, 'Netflix subscription'),
  (1, 'deposit', 500.00, 'Freelance project'),
  (1, 'withdrawal', 200.00, 'Cash withdrawal'),
  (1, 'purchase', 1200.00, 'Furniture purchase'),
  (1, 'deposit', 100.00, 'Birthday gift'),
  (1, 'purchase', 65.00, 'Grocery store'),
  (1, 'purchase', 45.50, 'Gas station'),
  (1, 'withdrawal', 75.00, 'ATM withdrawal'),
  (1, 'purchase', 999.99, 'Electronics'),
  (1, 'deposit', 300.00, 'Refund');

-- Insert transactions for savings account
INSERT INTO transactions (account_id, type, amount, description) VALUES
  (2, 'deposit', 5000.00, 'Initial savings'),
  (2, 'deposit', 500.00, 'Monthly savings'),
  (2, 'deposit', 500.00, 'Monthly savings'),
  (2, 'deposit', 500.00, 'Monthly savings'),
  (2, 'deposit', 500.00, 'Monthly savings'),
  (2, 'deposit', 500.00, 'Monthly savings'),
  (2, 'deposit', 2500.00, 'Year-end bonus'),
  (2, 'withdrawal', 1000.00, 'Emergency withdrawal'),
  (2, 'deposit', 500.00, 'Monthly savings');

-- Create balance history for checking account (simulate daily balances)
INSERT INTO account_history (account_id, balance, created_at) VALUES
  (1, 7200.00, NOW() - INTERVAL '30 days'),
  (1, 7450.00, NOW() - INTERVAL '28 days'),
  (1, 7295.00, NOW() - INTERVAL '26 days'),
  (1, 7355.00, NOW() - INTERVAL '24 days'),
  (1, 7105.00, NOW() - INTERVAL '22 days'),
  (1, 7405.00, NOW() - INTERVAL '20 days'),
  (1, 7092.01, NOW() - INTERVAL '18 days'),
  (1, 7592.01, NOW() - INTERVAL '16 days'),
  (1, 7355.00, NOW() - INTERVAL '14 days'),
  (1, 7610.00, NOW() - INTERVAL '12 days'),
  (1, 8010.00, NOW() - INTERVAL '10 days'),
  (1, 7810.00, NOW() - INTERVAL '8 days'),
  (1, 7865.00, NOW() - INTERVAL '6 days'),
  (1, 8165.00, NOW() - INTERVAL '4 days'),
  (1, 8500.00, NOW() - INTERVAL '2 days');

-- Create balance history for savings account
INSERT INTO account_history (account_id, balance, created_at) VALUES
  (2, 9000.00, NOW() - INTERVAL '30 days'),
  (2, 9500.00, NOW() - INTERVAL '28 days'),
  (2, 10000.00, NOW() - INTERVAL '26 days'),
  (2, 10500.00, NOW() - INTERVAL '24 days'),
  (2, 11000.00, NOW() - INTERVAL '22 days'),
  (2, 10500.00, NOW() - INTERVAL '20 days'),
  (2, 11000.00, NOW() - INTERVAL '18 days'),
  (2, 11500.00, NOW() - INTERVAL '16 days'),
  (2, 11500.00, NOW() - INTERVAL '14 days'),
  (2, 11500.00, NOW() - INTERVAL '12 days'),
  (2, 11500.00, NOW() - INTERVAL '10 days'),
  (2, 11500.00, NOW() - INTERVAL '8 days'),
  (2, 11500.00, NOW() - INTERVAL '6 days'),
  (2, 11500.00, NOW() - INTERVAL '4 days'),
  (2, 11500.00, NOW() - INTERVAL '2 days');
