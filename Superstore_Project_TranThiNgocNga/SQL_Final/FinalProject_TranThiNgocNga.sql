--Xóa các dữ liệu trùng còn soát lại của bảng OrderDetails nhằm mục đích tạo
--liên kết với bảng Orders (trước đó không tạo được ngoái ngoại do không khớp
--dữ liệu với nhau)
DELETE FROM dbo.OrderDetails
WHERE Order_ID NOT IN(
	SELECT Order_ID FROM dbo.Orders
);

--Thêm khóa ngoại sau khi nhập dữ liệu thành công
ALTER TABLE dbo.OrderDetails
ADD CONSTRAINT FK_OrderDetails_Orders
FOREIGN KEY (Order_ID)
REFERENCES dbo.Orders(Order_ID);

ALTER TABLE dbo.OrderDetails
ADD CONSTRAINT FK_OrderDetails_Products
FOREIGN KEY (Product_ID)
REFERENCES dbo.Products(Product_ID);

ALTER TABLE dbo.Orders
ADD CONSTRAINT FK_Orders_Customers
FOREIGN KEY (Customer_ID)
REFERENCES dbo.Customers(Customer_ID);

--Top 5 khách hàng đặt order nhiều nhất
SELECT TOP 5
	c.Customer_Name,
    SUM(od.Sales) AS TotalSales
FROM dbo.Customers c
LEFT JOIN dbo.Orders o ON c.Customer_ID = o.Customer_ID
LEFT JOIN dbo.OrderDetails od ON o.Order_ID = od.Order_ID
GROUP BY c.Customer_Name
ORDER BY TotalSales DESC;

--Top 5 sản phẩm doanh thu cao nhất từ năm 2015-2017
SELECT TOP 5
	p.Category,
    p.Product_Name,
    SUM(od.Sales) AS TotalSales
FROM dbo.OrderDetails od
LEFT JOIN dbo.Products p ON od.Product_ID = p.Product_ID
GROUP BY p.Product_Name, p.Category
ORDER BY TotalSales DESC;

--Top 5 tiểu bang, bang có số lượng order mua nhiều nhất
SELECT  TOP 5
	l.State,
	Sum(od.Sales) AS TotalSales_State
From dbo.Locations l
LEFT JOIN dbo.Orders o ON l.Postal_Code = o.Postal_Code
LEFT JOIN dbo.OrderDetails od ON o.Order_ID = od.Order_ID
GROUP BY l.State
ORDER BY TotalSales_State DESC;

