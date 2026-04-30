import { Pool, QueryResult } from 'pg'

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
})

export async function query<T = any>(text: string, params?: any[]): Promise<QueryResult<T>> {
  const client = await pool.connect()
  try {
    return await client.query<T>(text, params)
  } finally {
    client.release()
  }
}

export async function getUser(userId: number = 1) {
  const result = await query(
    'SELECT * FROM users WHERE id = $1',
    [userId]
  )
  return result.rows[0]
}

export async function getAccounts(userId: number = 1) {
  const result = await query(
    'SELECT * FROM accounts WHERE user_id = $1 ORDER BY created_at',
    [userId]
  )
  return result.rows
}

export async function getTransactions(accountId: number, limit: number = 20) {
  const result = await query(
    'SELECT * FROM transactions WHERE account_id = $1 ORDER BY created_at DESC LIMIT $2',
    [accountId, limit]
  )
  return result.rows
}

export async function getAccountHistory(accountId: number) {
  const result = await query(
    'SELECT * FROM account_history WHERE account_id = $1 ORDER BY created_at DESC',
    [accountId]
  )
  return result.rows
}

export async function transfer(
  fromAccountId: number,
  toAccountId: number,
  amount: number,
  description: string
) {
  const client = await pool.connect()
  try {
    await client.query('BEGIN')

    // Deduct from source account
    await client.query(
      'UPDATE accounts SET balance = balance - $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2',
      [amount, fromAccountId]
    )

    // Add to destination account
    await client.query(
      'UPDATE accounts SET balance = balance + $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2',
      [amount, toAccountId]
    )

    // Record transaction for source
    await client.query(
      'INSERT INTO transactions (account_id, type, amount, description) VALUES ($1, $2, $3, $4)',
      [fromAccountId, 'transfer', amount, `Transfer to ${description}`]
    )

    // Record transaction for destination
    await client.query(
      'INSERT INTO transactions (account_id, type, amount, description) VALUES ($1, $2, $3, $4)',
      [toAccountId, 'transfer', amount, `Transfer from ${description}`]
    )

    await client.query('COMMIT')
    return true
  } catch (error) {
    await client.query('ROLLBACK')
    throw error
  } finally {
    client.release()
  }
}
