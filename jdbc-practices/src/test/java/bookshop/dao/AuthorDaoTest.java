package bookshop.dao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;

import bookshop.vo.AuthorVo;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)

public class AuthorDaoTest {
	private static int count = 0;
	private static AuthorDao authorDao = new AuthorDao();
	private static AuthorVo mockAuthorVo = new AuthorVo();

	@BeforeAll
	public static void setUp() {
		count = authorDao.findAll().size();
	}
	
	@Test
	@Order(1)
	public void testInsert() {
		mockAuthorVo.setName("칼세이건");
		
		authorDao.insert(mockAuthorVo);

		assertNotNull(mockAuthorVo.getNo());
	}

	@Test
	@Order(2)
	public void testFindAll() {
		assertEquals(count + 1, authorDao.findAll().size());
	}
	
	@AfterAll
	public static void cleanUp() {
		authorDao.deleteByNo(mockAuthorVo.getNo());
	}	
}