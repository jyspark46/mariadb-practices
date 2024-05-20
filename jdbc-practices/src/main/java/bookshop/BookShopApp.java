package bookshop;

import bookshop.dao.AuthorDao;
import bookshop.dao.BookDao;
import bookshop.example.Book;

public class BookShopApp {
	private static AuthorDao authorDao = new AuthorDao();
	private static BookDao bookDao = new BookDao();
	
	public static void installDB() {
		//bookDao.deleteAll();
		//authorDao.deleteAll();
		
		Book[] books = new Book[10];

		books[0] = new Book(1, "트와일라잇", "스테파니메이어");
		books[1] = new Book(2, "뉴문", "스테파니메이어");
		books[2] = new Book(3, "이클립스", "스테파니메이어");
		books[3] = new Book(4, "브레이킹던", "스테파니메이어");
		books[4] = new Book(5, "아리랑", "조정래");
		books[5] = new Book(6, "젊은그들", "김동인");
		books[6] = new Book(7, "아프니깐 청춘이다", "김난도");
		books[7] = new Book(8, "귀천", "천상병");
		books[8] = new Book(9, "태백산맥", "조정래");
		books[9] = new Book(10, "풀하우스", "원수연");
	}

	public static void main(String[] args) {
		
		installDB();
		

	}
	
	private static void displayBookInfo(Book[] books) {
		for (Book book : books) {
			book.print();
		}
	}

}
