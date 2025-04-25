  List all orders with employee full names. (Inner join)
  SELECT * FROM employees
  SELECT * FROM orders
  SELECT order_id,first_name||' '||last_name as fullname FROM orders
  INNER JOIN employees 
  ON orders.employee_id=employees.employee_id
  
  