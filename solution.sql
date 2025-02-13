
-- List all books along with the names of their respective authors and publishers.
SELECT books.book_title, authors.author_name, publisher.name FROM books, authors, publisher 
WHERE
authors.author_id = books.author_id AND
publisher.publisher_id = books.publisher_id;


-- Count the number of distinct borrowers in each department.

SELECT 
    department,
    COUNT(DISTINCT borrower_id) AS number_of_borrowers
FROM borrowers
GROUP BY department;

-- Find the average number of copies available for each publisher's books.
SELECT 
    p.name AS publisher_name,
    AVG(b.no_of_copies - COALESCE(bb.borrowed_count, 0)) AS avg_available_copies
FROM publisher p
JOIN books b 
    ON p.publisher_id = b.publisher_id
LEFT JOIN (
    -- Subquery: Count how many copies of each book are currently borrowed
    SELECT book_id, COUNT(*) AS borrowed_count
    FROM borrow_book
    GROUP BY book_id
) bb 
    ON b.book_id = bb.book_id
GROUP BY p.name;

-- List the details of borrowers who have been fined more than once.
SELECT br.*, 
       COUNT(f.fine_id) AS times_fined
FROM borrowers br
JOIN borrow_book bb 
    ON br.borrower_id = bb.borrower_id
JOIN fine f
    ON f.borrow_id = bb.id
GROUP BY br.borrower_id, 
         br.firstname, 
         br.lastname, 
         br.address, 
         br.email, 
         br.phone, 
         br.department
HAVING COUNT(f.fine_id) > 1;

-- Retrieve a list of all borrowers who have borrowed books authored by 'J.K. Rowling'.
SELECT DISTINCT br.borrower_id,
       br.firstname,
       br.lastname,
       br.email,
       br.phone,
       br.address,
       br.department
FROM borrowers br
JOIN borrow_book bb
    ON br.borrower_id = bb.borrower_id
JOIN books bo
    ON bb.book_id = bo.book_id
JOIN authors a
    ON bo.author_id = a.author_id
WHERE a.author_name = 'J.K. Rowling';

-- Calculate the total fine collected by date.
SELECT 
    fine_date,
    SUM(fine_amount) AS total_fine_collected
FROM fine
GROUP BY fine_date;

-- Find the details of borrowers who have overdue books (i.e., duedate has passed)
SELECT 
    br.borrower_id,
    br.firstname,
    br.lastname,
    br.address,
    br.email,
    br.phone,
    br.department,
    bb.book_id,
    bb.borrowing_date,
    bb.due_date
FROM borrowers br
JOIN borrow_book bb
    ON br.borrower_id = bb.borrower_id
WHERE bb.due_date < CURRENT_DATE;

--Create a view that shows the title, author, and publisher for all books.
CREATE VIEW book_author_publisher AS
SELECT 
    b.book_title AS title,
    a.author_name AS author,
    p.name AS publisher
FROM books b
JOIN authors a 
    ON b.author_id = a.author_id
JOIN publisher p
    ON b.publisher_id = p.publisher_id;

-- Find the names of authors and their books where both the author's name and the book title start with the same letter.
SELECT a.author_name,
       b.book_title
FROM authors a
JOIN books b
    ON a.author_id = b.author_id
WHERE UPPER(LEFT(a.author_name, 1)) = UPPER(LEFT(b.book_title, 1));

-- Find the details of each borrower who has borrowed book at least two times
SELECT 
    br.borrower_id,
    br.firstname,
    br.lastname,
    br.address,
    br.email,
    br.phone,
    br.department,
    COUNT(bb.id) AS borrow_count
FROM borrowers br
JOIN borrow_book bb
    ON br.borrower_id = bb.borrower_id
GROUP BY 
    br.borrower_id, 
    br.firstname, 
    br.lastname, 
    br.address, 
    br.email, 
    br.phone, 
    br.department
HAVING COUNT(bb.id) >= 2;

--Find the name of each borrower with how much amount was fined.
SELECT 
    br.borrower_id,
    br.firstname,
    br.lastname,
    SUM(f.fine_amount) AS total_fine
FROM borrowers br
JOIN borrow_book bb 
    ON br.borrower_id = bb.borrower_id
JOIN fine f
    ON bb.id = f.borrow_id
GROUP BY 
    br.borrower_id, 
    br.firstname, 
    br.lastname;




