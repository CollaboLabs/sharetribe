class MigrateTransactionTypeToTransactionProcess < ActiveRecord::Migration
  def up
    execute("
    INSERT INTO transaction_processes (listing_shape_id, process, created_at, updated_at)
    (
      SELECT
        listing_shapes.id,
        IF(transaction_types.preauthorize_payment = 1, 'preauthorize', 'postpay'),
        listing_shapes.created_at,
        listing_shapes.updated_at
      FROM listing_shapes, transaction_types WHERE listing_shapes.transaction_type_id = transaction_types.id AND listing_shapes.id NOT IN
        (SELECT listing_shape_id FROM transaction_processes)
    )
")
  end

  def down
    execute("DELETE FROM transaction_processes")
  end
end
