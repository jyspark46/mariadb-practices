package bookshop.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bookshop.vo.AuthorVo;

public class AuthorDao {
	private Connection getConnection() throws SQLException {
		Connection conn = null;
		
		try {
			// 1. JDBC Driver 로딩
			Class.forName("org.mariadb.jdbc.Driver");
			
			// 2. 연결하기
			String url = "jdbc:mariadb://192.168.0.206:3306/webdb?charset=utf8";
			conn = DriverManager.getConnection(url, "webdb", "webdb");
		} catch (ClassNotFoundException e) {
			System.out.println("드라이버 로딩 실패: " + e);
		} 
	
		return conn;
	}
	
	public List<AuthorVo> findAll() {
		List<AuthorVo> result = new ArrayList<>();
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("select no, name from author");
			//ResultSet rs = pstmt.executeQuery(); // binding이 필요 없으면 rs를 여기서 !
		) {
			// 4. parameter binding
			
			// 5. SQL 실행하기
			ResultSet rs = pstmt.executeQuery(); // binding이 필요하면 rs를 여기서 !
			
			// 6. 결과 처리하기
			while(rs.next()) {
				Long no = rs.getLong(1);
				String name = rs.getString(2);
				
				AuthorVo vo = new AuthorVo();
				vo.setNo(no);
				vo.setName(name);
				
				result.add(vo);
			}
			
			rs.close();
		} catch (SQLException e) {
			System.out.println("error: " + e);
		}
	
		return result;
	}

	public int insert(AuthorVo vo) {
		int result = 0;;
		try (
				Connection conn = getConnection();
				PreparedStatement pstmt1 = conn.prepareStatement("insert into author(name) values(?)");
				PreparedStatement pstmt2 = conn.prepareStatement("select last_insert_id() from dual");
				//ResultSet rs = pstmt.executeQuery(); // binding이 필요 없으면 rs를 여기서 !
			) {
				// 4. parameter binding
				pstmt1.setString(1, vo.getName());
				result = pstmt1.executeUpdate();
				
				ResultSet rs = pstmt2.executeQuery();
				vo.setNo(rs.next() ? rs.getLong(1) : null);
				rs.close();
			} catch (SQLException e) {
				System.out.println("error: " + e);
			}
		
		return result;
	}

	public int deleteByNo(Long no) {
		int result = 0;
		
		try (
				Connection conn = getConnection();
				PreparedStatement pstmt = conn.prepareStatement("delete from author where no = ?");
			) {
				// 4. parameter binding
				pstmt.setLong(1, no);
				result = pstmt.executeUpdate();		
			} catch (SQLException e) {
				System.out.println("error: " + e);
			}
		
		return result;
	}
}