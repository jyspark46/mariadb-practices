package bookmall.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bookmall.vo.OrderBookVo;
import bookmall.vo.OrderVo;

public class OrderDao {
	private Connection getConnection() throws SQLException {
		Connection conn = null;
		
		try {
			// 1. JDBC Driver 로딩
			Class.forName("org.mariadb.jdbc.Driver");
			
			// 2. 연결하기
			String url = "jdbc:mariadb://192.168.0.206:3306/bookmall?charset=utf8";
			conn = DriverManager.getConnection(url, "bookmall", "bookmall");
		} catch (ClassNotFoundException e) {
			System.out.println("드라이버 로딩 실패: " + e);
		} 
	
		return conn;
	}

	public int insert(OrderVo mockOrderVo) {
		int result = 0;
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt1 = conn.prepareStatement("insert into orders(number, payment, shipping, status, user_no) values(?, ?, ?, ?, ?)");
			PreparedStatement pstmt2 = conn.prepareStatement("select last_insert_id() from dual");
		) {
			pstmt1.setString(1, mockOrderVo.getNumber());
			pstmt1.setLong(2, mockOrderVo.getPayment());
			pstmt1.setString(3, mockOrderVo.getShipping());
			pstmt1.setString(4, mockOrderVo.getStatus());
			pstmt1.setLong(5, mockOrderVo.getUserNo());
			result = pstmt1.executeUpdate();
			
			ResultSet rs = pstmt2.executeQuery();
			mockOrderVo.setNo(rs.next() ? rs.getLong(1) : null);
			
			rs.close();
		} catch (SQLException e) {
			System.out.println("error: " + e);
		}
		
		return result;
	}

	public int insertBook(OrderBookVo mockOrderBookVo) {
		int result = 0;
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt1 = conn.prepareStatement("insert into orders_book(order_no, book_no, quantity, price) values(?, ?, ?, ?)");
			PreparedStatement pstmt2 = conn.prepareStatement("select last_insert_id() from dual");
		) {
			pstmt1.setLong(1, mockOrderBookVo.getOrderNo());
			pstmt1.setLong(2, mockOrderBookVo.getBookNo());
			pstmt1.setLong(3, mockOrderBookVo.getQuantity());
			pstmt1.setLong(4, mockOrderBookVo.getPrice());
			result = pstmt1.executeUpdate();
			
			ResultSet rs = pstmt2.executeQuery();
			//mockOrderBookVo.setNo(rs.next() ? rs.getLong(1) : null);
			
			rs.close();
		} catch (SQLException e) {
			System.out.println("error: " + e);
		}
		
		return result;
		
	}

	public int deleteBooksByNo(Long no) {
		int result = 0;
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("delete from orders_book where order_no = ?");
		) {
			// 4. parameter binding
			pstmt.setLong(1, no);
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.out.println("error: " + e);
		}
		
		return result;
	}

	public int deleteByNo(Long no) {
		int result = 0;
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("delete from orders where no = ?");
		) {
			// 4. parameter binding
			pstmt.setLong(1, no);
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.out.println("error: " + e);
		}
		
		return result;
	}

	public OrderVo findByNoAndUserNo(Long no, Long userNo) {
		OrderVo result = null;
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("select number, payment, shipping, status from orders where no = " + no + " and user_no = " + userNo);
			ResultSet rs = pstmt.executeQuery();
		) {
			while(rs.next()) {
				String number = rs.getString(1);
				int payment = rs.getInt(2);
				String shipping = rs.getString(3);
				String status = rs.getString(4);
				
				result = new OrderVo();
				result.setNo(no);
				result.setNumber(number);
				result.setPayment(payment);
				result.setShipping(shipping);
				result.setStatus(status);
				result.setUserNo(userNo);
			}
		} catch (SQLException e) {
			System.out.println("error: " + e);
		}
		
		return result;
	}

	public List<OrderBookVo> findBooksByNoAndUserNo(Long orderNo, Long userNo) {
		List<OrderBookVo> result = new ArrayList<>();
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("select a.quantity, a.price, b.no, b.title from orders_book a, book b where a.book_no = b.no");
			ResultSet rs = pstmt.executeQuery();
		) {
			while(rs.next()) {
				int quantity = rs.getInt(1);
				int price = rs.getInt(2);
				Long bookNo = rs.getLong(3);
				String bookTitle = rs.getString(4);
				
				OrderBookVo vo = new OrderBookVo();
				vo.setOrderNo(orderNo);
				vo.setQuantity(quantity);
				vo.setPrice(price);
				vo.setBookNo(bookNo);
				vo.setBookTitle(bookTitle);
				
				result.add(vo);
			}
		} catch (SQLException e) {
			System.out.println("error: " + e);
		}
		
		return result;
	}
}