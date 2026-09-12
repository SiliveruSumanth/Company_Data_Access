CREATE DATABASE COGINIZANT_EXE;
USE COGINIZANT_EXE;

-- 1. USERS TABLE
CREATE TABLE USERS (
    user_id INT AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    registration_date DATE NOT NULL,

    CONSTRAINT PK_USERS PRIMARY KEY (user_id),
    CONSTRAINT U_USERS UNIQUE (email)
);

-- EVENTS
CREATE TABLE EVENTS(
	event_id INT AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    city VARCHAR(100) NOT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    status ENUM('upcoming','completed','cancelled'),
    organizer_id INT,
    CONSTRAINT PK_EVENTS PRIMARY KEY (event_id),
    CONSTRAINT FK_EVENTS_USERS FOREIGN KEY (organizer_id) REFERENCES USERS(user_id)
);


-- SESSIONS
CREATE TABLE SESSIONS(
	session_id INT AUTO_INCREMENT,
    event_id INT,
    title VARCHAR(200) NOT NULL,
    speaker_name VARCHAR(200) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
	CONSTRAINT PK_SESSIONS PRIMARY KEY (session_id),
    CONSTRAINT FK_EVENT_ID FOREIGN KEY (event_id) REFERENCES EVENTS(event_id)
);

-- REGISTRATIONS 
CREATE TABLE REGISTRATIONS (
    registration_id INT AUTO_INCREMENT,
    user_id INT,
    event_id INT,
    registration_date DATE NOT NULL,
    CONSTRAINT PK_REGISTRATIONS PRIMARY KEY (registration_id),
    CONSTRAINT FK_REGISTRATIONS_USERS FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CONSTRAINT FK_REGISTRATIONS_EVENTS FOREIGN KEY (event_id) REFERENCES EVENTS(event_id),
    CONSTRAINT UK_USER_EVENT UNIQUE (user_id, event_id)
);

-- FEEDBACK
CREATE TABLE FEEDBACK (
    feedback_id INT AUTO_INCREMENT,
    user_id INT,
    event_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    feedback_date DATE NOT NULL,
    CONSTRAINT PK_FEEDBACK PRIMARY KEY (feedback_id),
    CONSTRAINT FK_FEEDBACK_USERS FOREIGN KEY (user_id) REFERENCES USERS(user_id),
	CONSTRAINT FK_FEEDBACK_EVENTS FOREIGN KEY (event_id) REFERENCES EVENTS(event_id)
);

-- RESOURCES
CREATE TABLE RESOURCES (
    resource_id INT AUTO_INCREMENT,
    event_id INT,
    resource_type ENUM('pdf', 'image', 'link'),
    resource_url VARCHAR(255) NOT NULL,
    uploaded_at DATETIME NOT NULL,
    CONSTRAINT PK_RESOURCES PRIMARY KEY (resource_id),
    CONSTRAINT FK_RESOURCES_EVENTS FOREIGN KEY (event_id) REFERENCES EVENTS(event_id)
);

-- INSERTING DATA INTO USERS
INSERT INTO USERS
VALUES
    (1, 'Alice Johnson', 'alice@example.com', 'New York', '2024-12-01'),
    (2, 'Bob Smith', 'bob@example.com', 'Los Angeles', '2024-12-05'),
    (3, 'Charlie Lee', 'charlie@example.com', 'Chicago', '2024-12-10'),
    (4, 'Diana King', 'diana@example.com', 'New York', '2025-01-15'),
    (5, 'Ethan Hunt', 'ethan@example.com', 'Los Angeles', '2025-02-01');
    
-- INSERTING DATA INTO EVENTS
INSERT INTO EVENTS
VALUES
(1,
'Tech Innovators Meetup',
 'A meetup for tech enthusiasts.',
 'New York',
 '2025-06-10 10:00:00',
 '2025-06-10 16:00:00',
 'upcoming',
 1),

(2,
'AI & ML Conference',
 'Conference on AI and ML advancements.',
 'Chicago',
 '2025-05-15 09:00:00',
 '2025-05-15 17:00:00',
 'completed',
 3),

(3,
'Frontend Development Bootcamp',
 'Hands-on training on frontend tech.',
 'Los Angeles',
 '2025-07-01 10:00:00',
 '2025-07-03 16:00:00',
 'upcoming',
 2);    

 -- INSERTING DATA INTO SESSIONS
 INSERT INTO SESSIONS
(event_id, title, speaker_name, start_time, end_time)
VALUES
(1, 'Opening Keynote', 'Dr. Tech',
 '2025-06-10 10:00:00', '2025-06-10 11:00:00'),

(1, 'Future of Web Dev', 'Alice Johnson',
 '2025-06-10 11:15:00', '2025-06-10 12:30:00'),

(2, 'AI in Healthcare', 'Charlie Lee',
 '2025-05-15 09:30:00', '2025-05-15 11:00:00'),

(3, 'Intro to HTML5', 'Bob Smith',
 '2025-07-01 10:00:00', '2025-07-01 12:00:00');
 
 -- INSERTING DATA INTO REGISTRATIONS
 INSERT INTO REGISTRATIONS
(user_id, event_id, registration_date)
VALUES
(1, 1, '2025-05-01'),
(2, 1, '2025-05-02'),
(3, 2, '2025-04-30'),
(4, 2, '2025-04-28'),
(5, 3, '2025-06-15');

-- INSERTING DATA INTO FEEDBACK
INSERT INTO FEEDBACK
(user_id, event_id, rating, comments, feedback_date)
VALUES
(3, 2, 4, 'Great insights!', '2025-05-16'),
(4, 2, 5, 'Very informative.', '2025-05-16'),
(2, 1, 3, 'Could be better.', '2025-06-11');

-- INSERTING DATA INTO RESOURCES
INSERT INTO RESOURCES
(event_id, resource_type, resource_url, uploaded_at)
VALUES
(1, 'pdf',
 'https://portal.com/resources/tech_meetup_agenda.pdf',
 '2025-05-01 10:00:00'),

(2, 'image',
 'https://portal.com/resources/ai_poster.jpg',
 '2025-04-20 09:00:00'),

(3, 'link',
 'https://portal.com/resources/html5_docs',
 '2025-06-25 15:00:00');
 
 -- EXERCISES ON THE TABLES
 
 -- 1.Show a list of all upcoming events a user is registered for in their city, sorted by date.
SELECT e.* FROM EVENTS e JOIN REGISTRATIONS r ON r.event_id = e.event_id JOIN USERS u ON u.user_id = r.user_id WHERE e.status = 'upcoming' AND e.city = u.city ORDER BY e.start_date;
 -- 2.Identify events with the highest average rating, considering only those that have received at least 10 feedback submissions.
SELECT EVENT_ID, AVG(RATING) AS AVG_RATING FROM FEEDBACK GROUP BY EVENT_ID HAVING COUNT(*) >= 10 ORDER BY AVG(RATING) DESC LIMIT 1;

-- 3.Retrieve users who have not registered for any events in the last 90 days.
SELECT U.* FROM USERS U LEFT JOIN REGISTRATIONS R ON U.USER_ID = R.USER_ID and R.REGISTRATION_DATE BETWEEN CURDATE()-INTERVAL 90 DAY AND CURDATE() WHERE R.REGISTRATION_ID IS NULL;

-- 4.Count how many sessions are scheduled between 10 AM to 12 PM for each event
SELECT E.*, 
    (SELECT COUNT(*) 
     FROM SESSIONS S 
     WHERE S.EVENT_ID = E.EVENT_ID 
       AND TIME(S.START_TIME) BETWEEN '10:00:00' AND '12:00:00') AS COUNT_OF_EVENTS
FROM EVENTS E;

-- 5. Most Active Cities
-- List the top 5 cities with the highest number of distinct user registrations.
SELECT E.CITY AS CITY_NAME,COUNT(distinct R.USER_ID) AS TOTAL_REGISTRATIONS FROM EVENTS E JOIN REGISTRATIONS R ON R.EVENT_ID=E.EVENT_ID GROUP BY E.CITY ORDER BY TOTAL_REGISTRATIONS DESC LIMIT 5;

-- 6. Event Resource Summary
-- Generate a report showing the number of resources (PDFs, images, links) uploaded for each event.
SELECT E.EVENT_ID,
 SUM( CASE WHEN R.RESOURCE_TYPE LIKE 'PDF' THEN 1 ELSE 0 END) AS PDFS,
 SUM(CASE WHEN R.RESOURCE_TYPE LIKE 'IMAGE' THEN 1 ELSE 0 END) AS IMAGES,
 SUM(CASE WHEN R.RESOURCE_TYPE LIKE 'LINK' THEN 1 ELSE 0 END) AS LINKS
 FROM EVENTS E LEFT JOIN RESOURCES R ON E.EVENT_ID=R.EVENT_ID GROUP BY E.EVENT_ID;
 
-- 7. Low Feedback Alerts
-- List all users who gave feedback with a rating less than 3, along with their comments and associated event names.
SELECT U.*,F.COMMENTS,E.TITLE FROM USERS U JOIN FEEDBACK F ON F.USER_ID=U.USER_ID JOIN EVENTS E ON F.EVENT_ID=E.EVENT_ID WHERE F.RATING<3;

-- 8. Sessions per Upcoming Event
-- Display all upcoming events with the count of sessions scheduled for them.
SELECT E.*,COUNT(S.SESSION_ID) FROM EVENTS E LEFT JOIN SESSIONS S ON E.EVENT_ID=S.EVENT_ID WHERE E.STATUS='UPCOMING' GROUP BY E.EVENT_ID;

-- 9. Organizer Event Summary
-- For each event organizer, show the number of events created and their current status (upcoming, completed, cancelled).
SELECT E.ORGANIZER_ID,COUNT(*),E.STATUS FROM EVENTS E GROUP BY E.ORGANIZER_ID , E.STATUS;

-- 10. Feedback Gap
-- Identify events that had registrations but received no feedback at all.
SELECT E.* FROM EVENTS E JOIN REGISTRATIONS R ON E.EVENT_ID = R.EVENT_ID LEFT JOIN FEEDBACK F ON E.EVENT_ID = F.EVENT_ID WHERE F.FEEDBACK_ID IS NULL GROUP BY E.EVENT_ID;

-- 11. Daily New User Count
-- Find the number of users who registered each day in the last 7 days.


-- 12. Event with Maximum Sessions
-- List the event(s) with the highest number of sessions.
SELECT E.EVENT_ID, E.TITLE, COUNT(S.SESSION_ID) AS SESSION_COUNT FROM EVENTS E JOIN SESSIONS S ON E.EVENT_ID = S.EVENT_ID GROUP BY E.EVENT_ID, E.TITLE ORDER BY SESSION_COUNT DESC LIMIT 1;

-- 13. Average Rating per City
-- Calculate the average feedback rating of events conducted in each city.
SELECT E.CITY AS CITY_NAME , AVG(F.RATING) AS AVG_RATING FROM EVENTS E JOIN FEEDBACK F ON E.EVENT_ID=F.EVENT_ID GROUP BY E.CITY;

-- 14. Most Registered Events
-- List top 3 events based on the total number of user registrations.
SELECT E.TITLE , COUNT(R.USER_ID) AS TOTAL_REG FROM EVENTS E JOIN REGISTRATIONS R ON E.EVENT_ID=R.EVENT_ID GROUP BY E.TITLE,E.EVENT_ID ORDER BY TOTAL_REG DESC LIMIT 3;

-- 15. Event Session Time Conflict
-- Identify overlapping sessions within the same event (i.e., session start and end times that conflict).
SELECT E.* 
	FROM SESSIONS E 
    JOIN
    SESSIONS S 
    ON S.EVENT_ID=E.EVENT_ID
		WHERE 
			E.START_TIME < S.END_TIME
			AND 
            S.START_TIME < E.END_TIME
            AND
            E.SESSION_ID < S.SESSION_ID;
-- 16. Unregistered Active Users
-- Find users who created an account in the last 30 days but haven’t registered for any events.
SELECT U.* 
	FROM USERS U 
		LEFT JOIN 
	REGISTRATIONS R 
		ON
	U.USER_ID=R.USER_ID 
		WHERE
			U.REGISTRATION_DATE BETWEEN CURDATE()-INTERVAL 30 DAY AND CURDATE()
		AND
			R.REGISTRATION_ID IS NULL;


-- 17. Multi-Session Speakers
-- Identify speakers who are handling more than one session across all events.
SELECT S.SPEAKER_NAME FROM SESSIONS S GROUP BY S.SPEAKER_NAME HAVING COUNT(*)>1;

-- 18. Resource Availability Check
-- List all events that do not have any resources uploaded.
SELECT E.* FROM EVENTS E LEFT JOIN RESOURCES R ON E.EVENT_ID=R.EVENT_ID WHERE R.EVENT_ID IS NULL;

-- 19. Completed Events with Feedback Summary
-- For completed events, show total registrations and average feedback rating.

SELECT E.*,(
    SELECT COUNT(R.REGISTRATION_ID)
    FROM REGISTRATIONS R
    WHERE R.EVENT_ID = E.EVENT_ID
) AS TOTAL_REG,(
    SELECT AVG(F.RATING)
    FROM FEEDBACK F
    WHERE F.EVENT_ID = E.EVENT_ID
) AS AVG_RATING
FROM EVENTS E
WHERE E.STATUS = 'completed';

-- 20. User Engagement Index
-- For each user, calculate how many events they attended and how many feedbacks they submitted.
SELECT U.* ,
(
SELECT COUNT(R.USER_ID) FROM REGISTRATIONS R WHERE U.USER_ID=R.USER_ID GROUP BY U.USER_ID
) AS EVENTS_ATTENDED ,
(
SELECT COUNT(*) FROM FEEDBACK F WHERE F.USER_ID=U.USER_ID
) AS FEEDBACKS_SUBMITED
FROM USERS U;

-- 21. Top Feedback Providers
-- List top 5 users who have submitted the most feedback entries.
SELECT F.USER_ID, COUNT(F.USER_ID) FROM FEEDBACK F GROUP BY USER_ID ORDER BY COUNT(F.USER_ID) DESC LIMIT 5;

-- 22. Duplicate Registrations Check
-- Detect if a user has been registered more than once for the same event.
SELECT USER_ID ,EVENT_ID FROM REGISTRATIONS GROUP BY EVENT_ID,USER_ID HAVING COUNT(*)>1;

SELECT USER_ID, EVENT_ID
FROM REGISTRATIONS
WHERE (USER_ID, EVENT_ID) IN (
    SELECT USER_ID, EVENT_ID
    FROM REGISTRATIONS
    GROUP BY USER_ID, EVENT_ID
    HAVING COUNT(*) > 1
);

-- 23. Registration Trends
-- Show a month-wise registration count trend over the past 12 months.
SELECT
    DATE_FORMAT(REGISTRATION_DATE, '%Y-%m'),
    COUNT(*)
FROM REGISTRATIONS
WHERE
   DATE(REGISTRATION_DATE) BETWEEN CURDATE()-INTERVAL 12 MONTH AND CURDATE()
GROUP BY
    DATE_FORMAT(REGISTRATION_DATE, '%Y-%m')
ORDER BY
    DATE_FORMAT(REGISTRATION_DATE, '%Y-%m');

-- 24. Average Session Duration per Event
-- Compute the average duration (in minutes) of sessions in each event.
SELECT EVENT_ID,AVG(TIMESTAMPDIFF(MINUTE,START_TIME,END_TIME)) AS DURATION FROM SESSIONS GROUP BY EVENT_ID;

-- 25. Events Without Sessions
-- List all events that currently have no sessions scheduled under them.
SELECT E.* FROM EVENTS E LEFT JOIN SESSIONS S ON E.EVENT_ID=S.EVENT_ID WHERE S.EVENT_ID IS NULL;
