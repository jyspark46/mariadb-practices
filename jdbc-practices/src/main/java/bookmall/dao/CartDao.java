package bookmall.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bookmall.vo.CartVo;

public class CartDao {
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

	public int insert(CartVo mockCartVo) {
		int result = 0;
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt1 = conn.prepareStatement("insert into cart(user_no, book_no, quantity) values(?, ?, ?)");
			PreparedStatement pstmt2 = conn.prepareStatement("select last_insert_id() from dual");
		) {
			pstmt1.setLong(1, mockCartVo.getUserNo());
			pstmt1.setLong(2, mockCartVo.getBookNo());
			pstmt1.setLong(3, mockCartVo.getQuantity());
			result = pstmt1.executeUpdate();
			
			ResultSet rs = pstmt2.executeQuery();
			//mockCartVo.setUserNo(rs.next() ? rs.getLong(1) : null);
			
			rs.close();
		} catch (SQLException e) {
			System.out.println("error: " + e);
		}
		
		return result;		
	}

	public int deleteByUserNoAndBookNo(Long userNo, Long bookNo) {
		int result = 0;
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("delete from cart where user_no = ? and book_no = ?");
		) {
			// 4. parameter binding
			pstmt.setLong(1, userNo);
			pstmt.setLong(2, bookNo);
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.out.println("error: " + e);
		}
		
		return result;
	}

	public List<CartVo> findByUserNo(Long no) {
		List<CartVo> result = new ArrayList<>();
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("select a.no, a.title, b.quantity from book a, cart b where a.no = b.book_no");
			ResultSet rs = pstmt.executeQuery();
		) {
			while(rs.next()) {
				Long bookNo = rs.getLong(1);
				String title = rs.getString(2);
				int quantity = rs.getInt(3);
				
				CartVo vo = new CartVo();
				vo.setUserNo(no);
				vo.setBookNo(bookNo);
				vo.setBookTitle(title);
				vo.setQuantity(quantity);
				
				result.add(vo);
			}
		} catch (SQLException e) {
			System.out.println("error: " + e);
		}
		
		return result;
	}
}