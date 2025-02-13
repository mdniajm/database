SELECT books.book_title, authors.author_name, publisher.name FROM books, authors, publisher 
WHERE
authors.author_id = books.author_id AND
publisher.publisher_id = books.publisher_id
