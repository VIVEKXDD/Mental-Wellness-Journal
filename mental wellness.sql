create database mentalwellness;
use mentalwellness;

-- 1. User Table
CREATE TABLE User (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Password VARCHAR(255),
    DateOfBirth DATE,
    Gender ENUM('Male', 'Female', 'Other'),
    ProfilePicture VARCHAR(255),
    Preferences TEXT
);

-- 2. Mood Table
CREATE TABLE Mood (
    MoodID INT PRIMARY KEY AUTO_INCREMENT,
    MoodName VARCHAR(50),
    MoodIcon VARCHAR(255),
    MoodDescription TEXT
);

-- 3. JournalEntry Table
CREATE TABLE JournalEntry (
    EntryID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    Date DATE,
    MoodID INT,
    EntryContent TEXT,
    Tags TEXT,
    Geolocation VARCHAR(255),
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (MoodID) REFERENCES Mood(MoodID)
);

-- 4. Tag Table
CREATE TABLE Tag (
    TagID INT PRIMARY KEY AUTO_INCREMENT,
    TagName VARCHAR(50)
);

-- 5. Reminder Table
CREATE TABLE Reminder (
    ReminderID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    ReminderTime DATETIME,
    ReminderContent TEXT,
    RemindBefore INT,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

-- 6. Goal Table
CREATE TABLE Goal (
    GoalID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    GoalDescription TEXT,
    StartDate DATE,
    EndDate DATE,
    Progress INT,
    Frequency VARCHAR(20),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

-- 7. TherapistFeedback Table
CREATE TABLE TherapistFeedback (
    FeedbackID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    JournalEntryID INT,
    TherapistID INT,
    FeedbackContent TEXT,
    Date DATE,
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (JournalEntryID) REFERENCES JournalEntry(EntryID)
);

-- 8. CommunityPost Table
CREATE TABLE CommunityPost (
    PostID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    PostContent TEXT,
    PostDate DATE,
    Visibility ENUM('Public', 'Private', 'Anonymous'),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

-- 9. WellnessChallenge Table
CREATE TABLE WellnessChallenge (
    ChallengeID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    ChallengeDescription TEXT,
    Duration INT,
    ActiveStatus BOOLEAN,
    GoalTarget VARCHAR(50)
);

-- 10. EmotionTracking Table
CREATE TABLE EmotionTracking (
    EmotionID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    Date DATE,
    EmotionType VARCHAR(50),
    Intensity INT,
    Suggestions TEXT,
    EntryID INT,
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (EntryID) REFERENCES JournalEntry(EntryID)
);

-- 11. Resource Table
CREATE TABLE Resource (
    ResourceID INT PRIMARY KEY AUTO_INCREMENT,
    ResourceType ENUM('Article', 'Podcast', 'Video'),
    ResourceLink VARCHAR(255),
    ResourceDescription TEXT
);

INSERT INTO User (UserID, Name, Email, Password, DateOfBirth, Gender, ProfilePicture, Preferences) VALUES
(1, 'Sarah Johnson', 'sarah.j@email.com', 'hashed_pass1', '1990-05-15', 'Female', 'profile1.jpg', '{"theme":"dark","notifications":true}'),
(2, 'Michael Chen', 'michael.c@email.com', 'hashed_pass2', '1985-11-22', 'Male', 'profile2.jpg', '{"theme":"light","notifications":false}'),
(3, 'Emma Williams', 'emma.w@email.com', 'hashed_pass3', '1995-02-10', 'Female', 'profile3.jpg', '{"theme":"dark","notifications":true}'),
(4, 'David Kim', 'david.k@email.com', 'hashed_pass4', '1988-07-30', 'Male', 'profile4.jpg', '{"theme":"light","notifications":true}'),
(5, 'Priya Patel', 'priya.p@email.com', 'hashed_pass5', '1992-09-18', 'Female', 'profile5.jpg', '{"theme":"dark","notifications":false}'),
(6, 'James Wilson', 'james.w@email.com', 'hashed_pass6', '1983-04-25', 'Male', 'profile6.jpg', '{"theme":"light","notifications":true}'),
(7, 'Olivia Martinez', 'olivia.m@email.com', 'hashed_pass7', '1991-12-05', 'Female', 'profile7.jpg', '{"theme":"dark","notifications":false}'),
(8, 'Daniel Brown', 'daniel.b@email.com', 'hashed_pass8', '1987-03-14', 'Male', 'profile8.jpg', '{"theme":"light","notifications":true}'),
(9, 'Sophia Garcia', 'sophia.g@email.com', 'hashed_pass9', '1994-08-19', 'Female', 'profile9.jpg', '{"theme":"dark","notifications":true}'),
(10, 'Ethan Lee', 'ethan.l@email.com', 'hashed_pass10', '1989-06-22', 'Male', 'profile10.jpg', '{"theme":"light","notifications":false}'),
(11, 'Ava Rodriguez', 'ava.r@email.com', 'hashed_pass11', '1993-01-30', 'Female', 'profile11.jpg', '{"theme":"dark","notifications":true}'),
(12, 'Alexander Hernandez', 'alex.h@email.com', 'hashed_pass12', '1986-10-17', 'Male', 'profile12.jpg', '{"theme":"light","notifications":true}'),
(13, 'Mia Smith', 'mia.s@email.com', 'hashed_pass13', '1996-07-08', 'Female', 'profile13.jpg', '{"theme":"dark","notifications":false}'),
(14, 'Benjamin Davis', 'ben.d@email.com', 'hashed_pass14', '1984-09-11', 'Male', 'profile14.jpg', '{"theme":"light","notifications":true}'),
(15, 'Charlotte Wilson', 'charlotte.w@email.com', 'hashed_pass15', '1997-04-03', 'Female', 'profile15.jpg', '{"theme":"dark","notifications":true}'),
(16, 'William Thompson', 'william.t@email.com', 'hashed_pass16', '1982-12-28', 'Male', 'profile16.jpg', '{"theme":"light","notifications":false}'),
(17, 'Amelia Anderson', 'amelia.a@email.com', 'hashed_pass17', '1998-03-21', 'Female', 'profile17.jpg', '{"theme":"dark","notifications":true}'),
(18, 'Lucas White', 'lucas.w@email.com', 'hashed_pass18', '1981-11-14', 'Male', 'profile18.jpg', '{"theme":"light","notifications":true}'),
(19, 'Harper Jackson', 'harper.j@email.com', 'hashed_pass19', '1999-05-09', 'Female', 'profile19.jpg', '{"theme":"dark","notifications":false}'),
(20, 'Henry Martin', 'henry.m@email.com', 'hashed_pass20', '1980-08-16', 'Male', 'profile20.jpg', '{"theme":"light","notifications":true}'),
(21, 'Evelyn Lee', 'evelyn.l@email.com', 'hashed_pass21', '2000-02-12', 'Female', 'profile21.jpg', '{"theme":"dark","notifications":true}'),
(22, 'Sebastian Perez', 'sebastian.p@email.com', 'hashed_pass22', '1979-07-24', 'Male', 'profile22.jpg', '{"theme":"light","notifications":false}'),
(23, 'Abigail Taylor', 'abigail.t@email.com', 'hashed_pass23', '2001-10-31', 'Female', 'profile23.jpg', '{"theme":"dark","notifications":true}'),
(24, 'Jackson Moore', 'jackson.m@email.com', 'hashed_pass24', '1978-04-18', 'Male', 'profile24.jpg', '{"theme":"light","notifications":true}'),
(25, 'Emily Harris', 'emily.h@email.com', 'hashed_pass25', '2002-01-07', 'Female', 'profile25.jpg', '{"theme":"dark","notifications":false}'),
(26, 'Aiden Clark', 'aiden.c@email.com', 'hashed_pass26', '1977-06-29', 'Male', 'profile26.jpg', '{"theme":"light","notifications":true}'),
(27, 'Elizabeth Lewis', 'elizabeth.l@email.com', 'hashed_pass27', '2003-09-14', 'Female', 'profile27.jpg', '{"theme":"dark","notifications":true}'),
(28, 'Matthew Robinson', 'matthew.r@email.com', 'hashed_pass28', '1976-12-03', 'Male', 'profile28.jpg', '{"theme":"light","notifications":false}'),
(29, 'Sofia Walker', 'sofia.w@email.com', 'hashed_pass29', '2004-03-26', 'Female', 'profile29.jpg', '{"theme":"dark","notifications":true}'),
(30, 'Samuel Hall', 'samuel.h@email.com', 'hashed_pass30', '1975-10-11', 'Male', 'profile30.jpg', '{"theme":"light","notifications":true}'),
(31, 'Avery Allen', 'avery.a@email.com', 'hashed_pass31', '2005-05-19', 'Female', 'profile31.jpg', '{"theme":"dark","notifications":false}'),
(32, 'Joseph Young', 'joseph.y@email.com', 'hashed_pass32', '1974-08-22', 'Male', 'profile32.jpg', '{"theme":"light","notifications":true}'),
(33, 'Scarlett King', 'scarlett.k@email.com', 'hashed_pass33', '2006-02-15', 'Female', 'profile33.jpg', '{"theme":"dark","notifications":true}'),
(34, 'David Wright', 'david.w@email.com', 'hashed_pass34', '1973-11-28', 'Male', 'profile34.jpg', '{"theme":"light","notifications":false}'),
(35, 'Victoria Scott', 'victoria.s@email.com', 'hashed_pass35', '2007-07-04', 'Female', 'profile35.jpg', '{"theme":"dark","notifications":true}'),
(36, 'Christopher Green', 'christopher.g@email.com', 'hashed_pass36', '1972-04-09', 'Male', 'profile36.jpg', '{"theme":"light","notifications":true}'),
(37, 'Madison Adams', 'madison.a@email.com', 'hashed_pass37', '2008-09-23', 'Female', 'profile37.jpg', '{"theme":"dark","notifications":false}'),
(38, 'Andrew Baker', 'andrew.b@email.com', 'hashed_pass38', '1971-01-16', 'Male', 'profile38.jpg', '{"theme":"light","notifications":true}'),
(39, 'Lily Nelson', 'lily.n@email.com', 'hashed_pass39', '2009-12-07', 'Female', 'profile39.jpg', '{"theme":"dark","notifications":true}'),
(40, 'Joshua Carter', 'joshua.c@email.com', 'hashed_pass40', '1970-05-30', 'Male', 'profile40.jpg', '{"theme":"light","notifications":false}'),
(41, 'Grace Mitchell', 'grace.m@email.com', 'hashed_pass41', '2010-08-12', 'Female', 'profile41.jpg', '{"theme":"dark","notifications":true}'),
(42, 'Ryan Roberts', 'ryan.r@email.com', 'hashed_pass42', '1969-03-25', 'Male', 'profile42.jpg', '{"theme":"light","notifications":true}'),
(43, 'Chloe Phillips', 'chloe.p@email.com', 'hashed_pass43', '2011-10-18', 'Female', 'profile43.jpg', '{"theme":"dark","notifications":false}'),
(44, 'John Campbell', 'john.c@email.com', 'hashed_pass44', '1968-07-21', 'Male', 'profile44.jpg', '{"theme":"light","notifications":true}'),
(45, 'Zoey Parker', 'zoey.p@email.com', 'hashed_pass45', '2012-04-14', 'Female', 'profile45.jpg', '{"theme":"dark","notifications":true}'),
(46, 'Nathan Evans', 'nathan.e@email.com', 'hashed_pass46', '1967-09-06', 'Male', 'profile46.jpg', '{"theme":"light","notifications":false}'),
(47, 'Penelope Edwards', 'penelope.e@email.com', 'hashed_pass47', '2013-01-29', 'Female', 'profile47.jpg', '{"theme":"dark","notifications":true}'),
(48, 'Caleb Collins', 'caleb.c@email.com', 'hashed_pass48', '1966-12-10', 'Male', 'profile48.jpg', '{"theme":"light","notifications":true}'),
(49, 'Hannah Stewart', 'hannah.s@email.com', 'hashed_pass49', '2014-06-03', 'Female', 'profile49.jpg', '{"theme":"dark","notifications":false}'),
(50, 'Dylan Morris', 'dylan.m@email.com', 'hashed_pass50', '1965-02-27', 'Male', 'profile50.jpg', '{"theme":"light","notifications":true}');

INSERT INTO Mood (MoodID, MoodName, MoodIcon, MoodDescription) VALUES
(1, 'Happy', 'smile.png', 'Feeling joyful and content'),
(2, 'Sad', 'frown.png', 'Feeling down or unhappy'),
(3, 'Angry', 'angry.png', 'Feeling frustrated or mad'),
(4, 'Anxious', 'anxious.png', 'Feeling nervous or worried'),
(5, 'Excited', 'excited.png', 'Feeling enthusiastic and eager'),
(6, 'Calm', 'calm.png', 'Feeling peaceful and relaxed'),
(7, 'Stressed', 'stressed.png', 'Feeling overwhelmed or pressured'),
(8, 'Tired', 'tired.png', 'Feeling exhausted or low energy'),
(9, 'Confused', 'confused.png', 'Feeling uncertain or puzzled'),
(10, 'Bored', 'bored.png', 'Feeling uninterested or unengaged'),
(11, 'Grateful', 'grateful.png', 'Feeling thankful and appreciative'),
(12, 'Lonely', 'lonely.png', 'Feeling isolated or disconnected'),
(13, 'Hopeful', 'hopeful.png', 'Feeling optimistic about the future'),
(14, 'Proud', 'proud.png', 'Feeling satisfied with achievements'),
(15, 'Guilty', 'guilty.png', 'Feeling remorseful or regretful'),
(16, 'Jealous', 'jealous.png', 'Feeling envious of others'),
(17, 'Surprised', 'surprised.png', 'Feeling astonished or caught off guard'),
(18, 'Disappointed', 'disappointed.png', 'Feeling let down or unsatisfied'),
(19, 'Loved', 'loved.png', 'Feeling cared for and valued'),
(20, 'Neutral', 'neutral.png', 'Feeling neither positive nor negative');

INSERT INTO JournalEntry (EntryID, UserID, Date, MoodID, EntryContent, Tags, Geolocation) VALUES
(1, 1, '2023-01-15', 1, 'Had a wonderful day at the park with friends. The weather was perfect!', '1,11', '40.7128,-74.0060'),
(2, 2, '2023-01-16', 4, 'Feeling anxious about the upcoming presentation at work. Need to practice more.', '4,7', '34.0522,-118.2437'),
(3, 3, '2023-01-17', 6, 'Meditated for 20 minutes today. Feeling much calmer than yesterday.', '8,11', '41.8781,-87.6298'),
(4, 4, '2023-01-18', 2, 'Missing my family back home. Wish I could visit them soon.', '12', '29.7604,-95.3698'),
(5, 5, '2023-01-19', 5, 'Got promoted at work today! So excited for this new opportunity.', '14', '39.9526,-75.1652'),
(6, 6, '2023-01-20', 7, 'Too much work and not enough time. Need to prioritize better.', '4,7', '47.6062,-122.3321'),
(7, 7, '2023-01-21', 3, 'Angry at myself for procrastinating on important tasks.', '4,15', '32.7157,-117.1611'),
(8, 8, '2023-01-22', 8, 'Exhausted after working all weekend. Need proper rest.', '7', '39.7392,-104.9903'),
(9, 9, '2023-01-23', 11, 'Grateful for my supportive partner who helped me through a tough day.', '1,11', '30.2672,-97.7431'),
(10, 10, '2023-01-24', 9, 'Confused about which career path to take. Need to reflect more.', '4', '35.2271,-80.8431'),
(11, 11, '2023-01-25', 10, 'Nothing interesting happening. Feeling bored with my routine.', '12', '40.7128,-74.0060'),
(12, 12, '2023-01-26', 12, 'Haven''t seen friends in weeks. Feeling lonely lately.', '12', '34.0522,-118.2437'),
(13, 13, '2023-01-27', 13, 'Started a new project. Hopeful it will turn out well.', '14', '41.8781,-87.6298'),
(14, 14, '2023-01-28', 14, 'Proud of finishing my first 5K run today!', '14', '29.7604,-95.3698'),
(15, 15, '2023-01-29', 15, 'Regret saying something hurtful to my sister. Need to apologize.', '15', '39.9526,-75.1652'),
(16, 16, '2023-01-30', 16, 'Jealous of my colleague''s success. Need to work on my own goals.', '4,16', '47.6062,-122.3321'),
(17, 17, '2023-01-31', 17, 'Surprised by a birthday party my friends threw me!', '1,19', '32.7157,-117.1611'),
(18, 18, '2023-02-01', 18, 'Disappointed my vacation plans got canceled.', '12', '39.7392,-104.9903'),
(19, 19, '2023-02-02', 19, 'Feeling loved after a heart-to-heart with my parents.', '1,11,19', '30.2672,-97.7431'),
(20, 20, '2023-02-03', 20, 'Just an ordinary day. Nothing special to report.', NULL, '35.2271,-80.8431'),
(21, 21, '2023-02-04', 1, 'Had a great time at the beach today!', '1,11', '40.7128,-74.0060'),
(22, 22, '2023-02-05', 2, 'Feeling sad after watching a emotional movie.', '12', '34.0522,-118.2437'),
(23, 23, '2023-02-06', 3, 'Angry at the traffic that made me late for work.', '4', '41.8781,-87.6298'),
(24, 24, '2023-02-07', 4, 'Anxious about my doctor''s appointment tomorrow.', '4,7', '29.7604,-95.3698'),
(25, 25, '2023-02-08', 5, 'Excited about my upcoming trip to Europe!', '1,14', '39.9526,-75.1652'),
(26, 26, '2023-02-09', 6, 'Calm evening with a good book and tea.', '8,11', '47.6062,-122.3321'),
(27, 27, '2023-02-10', 7, 'Stressed about meeting multiple deadlines.', '4,7', '32.7157,-117.1611'),
(28, 28, '2023-02-11', 8, 'Tired after a long week. Need to recharge.', '7', '39.7392,-104.9903'),
(29, 29, '2023-02-12', 9, 'Confused about my feelings in this relationship.', '4', '30.2672,-97.7431'),
(30, 30, '2023-02-13', 10, 'Bored during the weekend with nothing to do.', '12', '35.2271,-80.8431'),
(31, 31, '2023-02-14', 11, 'Grateful for my health and loving family.', '1,11', '40.7128,-74.0060'),
(32, 32, '2023-02-15', 12, 'Lonely after moving to a new city.', '12', '34.0522,-118.2437'),
(33, 33, '2023-02-16', 13, 'Hopeful about my job interview next week.', '14', '41.8781,-87.6298'),
(34, 34, '2023-02-17', 14, 'Proud of completing my first painting!', '14', '29.7604,-95.3698'),
(35, 35, '2023-02-18', 15, 'Guilty about eating too much junk food.', '15', '39.9526,-75.1652'),
(36, 36, '2023-02-19', 16, 'Jealous of my friend''s new car.', '16', '47.6062,-122.3321'),
(37, 37, '2023-02-20', 17, 'Surprised by a unexpected gift from my coworker.', '1,19', '32.7157,-117.1611'),
(38, 38, '2023-02-21', 18, 'Disappointed my favorite show got canceled.', '12', '39.7392,-104.9903'),
(39, 39, '2023-02-22', 19, 'Feeling loved after a romantic dinner.', '1,19', '30.2672,-97.7431'),
(40, 40, '2023-02-23', 20, 'Just another regular work day.', NULL, '35.2271,-80.8431'),
(41, 41, '2023-02-24', 1, 'Happy to see my old college friends after years!', '1,11', '40.7128,-74.0060'),
(42, 42, '2023-02-25', 2, 'Sad about my pet being sick.', '12', '34.0522,-118.2437'),
(43, 43, '2023-02-26', 3, 'Angry at the unfair treatment at work.', '4', '41.8781,-87.6298'),
(44, 44, '2023-02-27', 4, 'Anxious about public speaking tomorrow.', '4,7', '29.7604,-95.3698'),
(45, 45, '2023-02-28', 5, 'Excited to start my new fitness routine!', '14', '39.9526,-75.1652'),
(46, 46, '2023-03-01', 6, 'Calm morning meditation was refreshing.', '8,11', '47.6062,-122.3321'),
(47, 47, '2023-03-02', 7, 'Stressed about financial situation.', '4,7', '32.7157,-117.1611'),
(48, 48, '2023-03-03', 8, 'Tired from traveling all day.', '7', '39.7392,-104.9903'),
(49, 49, '2023-03-04', 9, 'Confused about mixed signals from a date.', '4', '30.2672,-97.7431'),
(50, 50, '2023-03-05', 10, 'Bored at home on a rainy day.', '12', '35.2271,-80.8431');

INSERT INTO Tag (TagID, TagName) VALUES
(1, 'Friends'),
(2, 'Family'),
(3, 'Work'),
(4, 'Stress'),
(5, 'Exercise'),
(6, 'Health'),
(7, 'Workload'),
(8, 'Meditation'),
(9, 'Nature'),
(10, 'Creativity'),
(11, 'Gratitude'),
(12, 'Loneliness'),
(13, 'Achievement'),
(14, 'Goals'),
(15, 'Regret'),
(16, 'Envy'),
(17, 'Surprise'),
(18, 'Disappointment'),
(19, 'Love'),
(20, 'Routine');

INSERT INTO Reminder (ReminderID, UserID, ReminderTime, ReminderContent, RemindBefore) VALUES
(1, 1, '2023-01-15 08:00:00', 'Morning journal entry', 15),
(2, 2, '2023-01-16 12:30:00', 'Lunchtime mindfulness', 10),
(3, 3, '2023-01-17 19:00:00', 'Evening reflection', 5),
(4, 4, '2023-01-18 07:15:00', 'Gratitude journal', 15),
(5, 5, '2023-01-19 21:00:00', 'Daily review', 5),
(6, 6, '2023-01-20 09:00:00', 'Work goals planning', 15),
(7, 7, '2023-01-21 16:45:00', 'Afternoon break', 5),
(8, 8, '2023-01-22 08:30:00', 'Weekly review', 30),
(9, 9, '2023-01-23 13:00:00', 'Breathing exercise', 10),
(10, 10, '2023-01-24 20:00:00', 'Mood tracking', 5),
(11, 11, '2023-01-25 07:00:00', 'Morning meditation', 15),
(12, 12, '2023-01-26 18:00:00', 'Exercise session', 10),
(13, 13, '2023-01-27 22:00:00', 'Sleep reflection', 5),
(14, 14, '2023-01-28 10:00:00', 'Weekend planning', 15),
(15, 15, '2023-01-29 15:30:00', 'Tea break reflection', 5),
(16, 16, '2023-01-30 08:45:00', 'Daily intentions', 15),
(17, 17, '2023-01-31 12:00:00', 'Lunch break journal', 10),
(18, 18, '2023-02-01 17:00:00', 'Evening walk', 5),
(19, 19, '2023-02-02 09:30:00', 'Creative writing', 15),
(20, 20, '2023-02-03 14:00:00', 'Afternoon check-in', 10),
(21, 21, '2023-02-04 11:00:00', 'Weekend reflection', 15),
(22, 22, '2023-02-05 19:30:00', 'Daily gratitude', 5),
(23, 23, '2023-02-06 08:15:00', 'Morning pages', 15),
(24, 24, '2023-02-07 13:45:00', 'Mindful eating', 10),
(25, 25, '2023-02-08 20:15:00', 'Evening journal', 5),
(26, 26, '2023-02-09 07:30:00', 'Yoga practice', 15),
(27, 27, '2023-02-10 16:00:00', 'Work wrap-up', 10),
(28, 28, '2023-02-11 10:30:00', 'Self-care time', 15),
(29, 29, '2023-02-12 21:30:00', 'Bedtime reflection', 5),
(30, 30, '2023-02-13 09:45:00', 'Daily planning', 15),
(31, 31, '2023-02-14 12:15:00', 'Lunch journal', 10),
(32, 32, '2023-02-15 18:30:00', 'Evening meditation', 5),
(33, 33, '2023-02-16 08:00:00', 'Goal review', 15),
(34, 34, '2023-02-17 14:45:00', 'Creative break', 10),
(35, 35, '2023-02-18 20:45:00', 'Daily highlights', 5),
(36, 36, '2023-02-19 07:15:00', 'Morning walk', 15),
(37, 37, '2023-02-20 11:30:00', 'Mindfulness check', 10),
(38, 38, '2023-02-21 17:15:00', 'Workout session', 5),
(39, 39, '2023-02-22 09:00:00', 'Journal prompts', 15),
(40, 40, '2023-02-23 13:30:00', 'Afternoon journal', 10),
(41, 41, '2023-02-24 19:45:00', 'Daily reflection', 5),
(42, 42, '2023-02-25 08:30:00', 'Weekend journal', 15),
(43, 43, '2023-02-26 15:00:00', 'Self-reflection', 10),
(44, 44, '2023-02-27 21:15:00', 'Gratitude practice', 5),
(45, 45, '2023-02-28 10:45:00', 'Creative journaling', 15),
(46, 46, '2023-03-01 12:45:00', 'Midday check-in', 10),
(47, 47, '2023-03-02 18:00:00', 'Evening routine', 5),
(48, 48, '2023-03-03 07:45:00', 'Morning intention', 15),
(49, 49, '2023-03-04 14:30:00', 'Weekend planning', 10),
(50, 50, '2023-03-05 20:30:00', 'Sleep preparation', 5);

INSERT INTO Goal (GoalID, UserID, GoalDescription, StartDate, EndDate, Progress, Frequency) VALUES
(1, 1, 'Write daily journal entries', '2023-01-01', '2023-12-31', 75, 'daily'),
(2, 2, 'Meditate for 10 minutes daily', '2023-01-01', '2023-03-31', 60, 'daily'),
(3, 3, 'Exercise 3 times per week', '2023-01-01', '2023-06-30', 45, 'weekly'),
(4, 4, 'Write 3 gratitude notes weekly', '2023-01-01', '2023-12-31', 80, 'weekly'),
(5, 5, 'Reduce screen time before bed', '2023-01-01', '2023-02-28', 90, 'daily'),
(6, 6, 'Read 1 book per month', '2023-01-01', '2023-12-31', 25, 'monthly'),
(7, 7, 'Practice mindfulness daily', '2023-01-01', '2023-06-30', 70, 'daily'),
(8, 8, 'Walk 10,000 steps daily', '2023-01-01', '2023-03-31', 55, 'daily'),
(9, 9, 'Learn new recipe weekly', '2023-01-01', '2023-12-31', 30, 'weekly'),
(10, 10, 'Digital detox every Sunday', '2023-01-01', '2023-12-31', 65, 'weekly'),
(11, 11, 'Write morning pages daily', '2023-01-01', '2023-06-30', 85, 'daily'),
(12, 12, 'Call family members weekly', '2023-01-01', '2023-12-31', 75, 'weekly'),
(13, 13, 'Practice yoga 2 times weekly', '2023-01-01', '2023-06-30', 50, 'weekly'),
(14, 14, 'Limit caffeine after 2pm', '2023-01-01', '2023-03-31', 95, 'daily'),
(15, 15, 'Write one poem weekly', '2023-01-01', '2023-12-31', 40, 'weekly'),
(16, 16, 'No social media after 9pm', '2023-01-01', '2023-06-30', 80, 'daily'),
(17, 17, 'Volunteer once a month', '2023-01-01', '2023-12-31', 20, 'monthly'),
(18, 18, 'Drink 8 glasses of water daily', '2023-01-01', '2023-03-31', 70, 'daily'),
(19, 19, 'Practice guitar 15 min daily', '2023-01-01', '2023-06-30', 60, 'daily'),
(20, 20, 'Weekly digital organization', '2023-01-01', '2023-12-31', 45, 'weekly'),
(21, 21, 'Morning run 3 times weekly', '2023-01-01', '2023-06-30', 55, 'weekly'),
(22, 22, 'Write thank you notes monthly', '2023-01-01', '2023-12-31', 30, 'monthly'),
(23, 23, 'No work emails after 7pm', '2023-01-01', '2023-03-31', 85, 'daily'),
(24, 24, 'Read news only once daily', '2023-01-01', '2023-06-30', 75, 'daily'),
(25, 25, 'Try new hobby monthly', '2023-01-01', '2023-12-31', 15, 'monthly'),
(26, 26, 'Evening meditation daily', '2023-01-01', '2023-06-30', 65, 'daily'),
(27, 27, 'Weekly meal planning', '2023-01-01', '2023-12-31', 50, 'weekly'),
(28, 28, 'Digital journaling daily', '2023-01-01', '2023-03-31', 90, 'daily'),
(29, 29, 'Practice French 15 min daily', '2023-01-01', '2023-06-30', 40, 'daily'),
(30, 30, 'Monthly self-reflection', '2023-01-01', '2023-12-31', 25, 'monthly'),
(31, 31, 'Morning gratitude practice', '2023-01-01', '2023-06-30', 80, 'daily'),
(32, 32, 'Weekly nature walks', '2023-01-01', '2023-12-31', 60, 'weekly'),
(33, 33, 'Limit takeout to twice weekly', '2023-01-01', '2023-03-31', 70, 'weekly'),
(34, 34, 'Daily creative writing', '2023-01-01', '2023-06-30', 55, 'daily'),
(35, 35, 'Monthly friend meetups', '2023-01-01', '2023-12-31', 35, 'monthly'),
(36, 36, 'Evening reading habit', '2023-01-01', '2023-03-31', 75, 'daily'),
(37, 37, 'Weekly digital art practice', '2023-01-01', '2023-06-30', 45, 'weekly'),
(38, 38, 'No phone first hour awake', '2023-01-01', '2023-12-31', 85, 'daily'),
(39, 39, 'Cook new recipe weekly', '2023-01-01', '2023-06-30', 50, 'weekly'),
(40, 40, 'Monthly skill development', '2023-01-01', '2023-12-31', 20, 'monthly'),
(41, 41, 'Daily stretching routine', '2023-01-01', '2023-03-31', 90, 'daily'),
(42, 42, 'Weekly digital declutter', '2023-01-01', '2023-06-30', 65, 'weekly'),
(43, 43, 'Evening gratitude journal', '2023-01-01', '2023-12-31', 70, 'daily'),
(44, 44, 'Monthly museum visits', '2023-01-01', '2023-06-30', 15, 'monthly'),
(45, 45, 'Daily water tracking', '2023-01-01', '2023-03-31', 95, 'daily'),
(46, 46, 'Weekly podcast listening', '2023-01-01', '2023-12-31', 55, 'weekly'),
(47, 47, 'Morning visualization', '2023-01-01', '2023-06-30', 75, 'daily'),
(48, 48, 'Monthly book club', '2023-01-01', '2023-12-31', 30, 'monthly'),
(49, 49, 'Daily positive affirmations', '2023-01-01', '2023-03-31', 80, 'daily'),
(50, 50, 'Weekly digital detox', '2023-01-01', '2023-06-30', 60, 'weekly');

INSERT INTO CommunityPost (PostID, UserID, PostContent, PostDate, Visibility) VALUES
(1, 1, 'Does anyone else find journaling helps with morning anxiety?', '2023-01-15 08:12:34', 'Public'),
(2, 2, 'Sharing my 30-day meditation challenge results - life changing!', '2023-01-16 12:30:45', 'Public'),
(3, 3, 'Looking for accountability partner for daily journaling', '2023-01-17 19:05:22', 'Public'),
(4, 4, 'How do you deal with homesickness?', '2023-01-18 07:45:18', 'Public'),
(5, 5, 'Just got promoted at work! So excited to share this win', '2023-01-19 21:15:33', 'Public'),
(6, 6, 'Work stress is overwhelming me lately', '2023-01-20 09:30:47', 'Anonymous'),
(7, 7, 'My procrastination is getting worse - any tips?', '2023-01-21 16:50:12', 'Public'),
(8, 8, 'After burnout recovery, here are my self-care strategies', '2023-01-22 08:25:09', 'Public'),
(9, 9, 'Gratitude journaling has transformed my outlook', '2023-01-23 13:10:51', 'Public'),
(10, 10, 'Career crossroads - how did you choose your path?', '2023-01-24 20:35:27', 'Anonymous'),
(11, 11, 'Boredom as a catalyst for creativity - my experience', '2023-01-25 07:20:44', 'Public'),
(12, 12, 'Loneliness in a new city - how to make friends as an adult?', '2023-01-26 18:15:38', 'Public'),
(13, 13, 'Pre-interview anxiety management techniques?', '2023-01-27 22:05:19', 'Public'),
(14, 14, 'Completed my first 5K run today! Never thought I could do it', '2023-01-28 10:40:56', 'Public'),
(15, 15, 'How to apologize effectively?', '2023-01-29 15:55:23', 'Anonymous'),
(16, 16, 'Dealing with jealousy towards a colleague', '2023-01-30 08:50:17', 'Public'),
(17, 17, 'Surprise birthday party made me realize how loved I am', '2023-01-31 12:25:41', 'Public'),
(18, 18, 'Cancelled vacation blues - how to cope?', '2023-02-01 17:35:28', 'Public'),
(19, 19, 'Heart-to-heart with parents after years of distance', '2023-02-02 09:45:12', 'Public'),
(20, 20, 'The beauty of ordinary days', '2023-02-03 14:20:39', 'Public'),
(21, 21, 'Beach therapy - why nature resets my mind', '2023-02-04 11:30:54', 'Public'),
(22, 22, 'Emotional movies as catharsis - anyone else?', '2023-02-05 19:40:26', 'Public'),
(23, 23, 'Road rage and mindfulness - my work in progress', '2023-02-06 08:15:47', 'Anonymous'),
(24, 24, 'Medical anxiety support group?', '2023-02-07 13:50:33', 'Public'),
(25, 25, 'Europe trip planning - solo travel tips?', '2023-02-08 20:25:18', 'Public'),
(26, 26, 'Evening tea ritual for relaxation', '2023-02-09 07:35:42', 'Public'),
(27, 27, 'Multiple deadline stress management', '2023-02-10 16:45:29', 'Public'),
(28, 28, 'Recovery practices after intense work periods', '2023-02-11 10:30:15', 'Public'),
(29, 29, 'Mixed signals in dating - how to interpret?', '2023-02-12 21:40:57', 'Anonymous'),
(30, 30, 'Rainy day activities for mental wellness?', '2023-02-13 09:55:24', 'Public'),
(31, 31, 'Health gratitude practice changed my perspective', '2023-02-14 12:20:38', 'Public'),
(32, 32, 'Moving to new city - loneliness strategies', '2023-02-15 18:30:45', 'Public'),
(33, 33, 'Job interview success stories?', '2023-02-16 08:10:52', 'Public'),
(34, 34, 'First painting completed - embracing creativity', '2023-02-17 14:45:19', 'Public'),
(35, 35, 'Emotional eating patterns - how to break?', '2023-02-18 20:55:36', 'Anonymous'),
(36, 36, 'Comparison trap with friends'' achievements', '2023-02-19 07:25:43', 'Public'),
(37, 37, 'Unexpected kindness from coworker - faith in humanity restored', '2023-02-20 11:35:28', 'Public'),
(38, 38, 'Favorite show cancelled - disproportionate sadness?', '2023-02-21 17:40:15', 'Public'),
(39, 39, 'Romantic gestures that actually matter', '2023-02-22 09:50:42', 'Public'),
(40, 40, 'Work-life balance in demanding jobs', '2023-02-23 13:30:57', 'Public'),
(41, 41, 'College reunion - nostalgia and personal growth', '2023-02-24 19:45:23', 'Public'),
(42, 42, 'Pet illness anxiety - coping mechanisms?', '2023-02-25 08:35:16', 'Public'),
(43, 43, 'Workplace unfairness - when to speak up?', '2023-02-26 15:20:49', 'Anonymous'),
(44, 44, 'Public speaking journey - from fear to confidence', '2023-02-27 21:10:34', 'Public'),
(45, 45, 'Fitness routine motivation tips?', '2023-02-28 10:40:25', 'Public'),
(46, 46, 'Meditation consistency - how to maintain?', '2023-03-01 12:50:18', 'Public'),
(47, 47, 'Financial stress and mental health connection', '2023-03-02 18:05:42', 'Public'),
(48, 48, 'Business travel exhaustion - survival tips?', '2023-03-03 07:55:31', 'Public'),
(49, 49, 'Dating ambiguity - modern relationship challenges', '2023-03-04 14:30:45', 'Anonymous'),
(50, 50, 'Rainy day contemplation - silver linings?', '2023-03-05 20:15:29', 'Public');

INSERT INTO WellnessChallenge (ChallengeID, `Name`, ChallengeDescription, Duration, ActiveStatus, GoalTarget) VALUES
(1, '30-Day Gratitude Challenge', 'Write down 3 things youre grateful for every day for 30 days', 30, 1, 'Daily gratitude practice'),
(2, 'Mindful March', 'Practice 10 minutes of mindfulness daily throughout March', 31, 1, 'Establish meditation habit'),
(3, 'Digital Detox Week', 'Reduce screen time by 50% for one week', 7, 1, 'Break digital addiction'),
(4, '7-Day Sleep Challenge', 'Follow optimal sleep hygiene practices for a week', 7, 1, 'Improve sleep quality'),
(5, '21-Day Yoga Journey', 'Complete a daily yoga session for 21 days', 21, 1, 'Build yoga practice'),
(6, '14-Day Kindness Challenge', 'Perform one intentional act of kindness daily', 14, 1, 'Increase compassion'),
(7, 'Hydration Challenge', 'Drink 8 glasses of water daily for 30 days', 30, 1, 'Improve hydration'),
(8, '90-Day Fitness Transformation', 'Regular exercise and healthy eating for 90 days', 90, 1, 'Healthier lifestyle'),
(9, '28-Day Journaling Journey', 'Write a journal entry every day for 28 days', 28, 1, 'Develop journaling habit'),
(10, '5-Day Social Media Fast', 'Complete abstinence from social media', 5, 1, 'Reduce social media use'),
(11, '60-Day Reading Challenge', 'Read for 30 minutes daily for 60 days', 60, 1, 'Cultivate reading habit'),
(12, '7-Day Green Smoothie Challenge', 'Consume one green smoothie daily', 7, 1, 'Increase vegetable intake'),
(13, '30-Day Declutter Challenge', 'Remove one unnecessary item daily for a month', 30, 1, 'Reduce clutter'),
(14, '14-Day Digital Organization', 'Organize digital files and emails daily', 14, 1, 'Reduce digital chaos'),
(15, '21-Day Sugar Detox', 'Eliminate added sugars from diet', 21, 1, 'Reduce sugar consumption'),
(16, '30-Day Walking Challenge', 'Walk 10,000 steps daily for a month', 30, 1, 'Increase physical activity'),
(17, '7-Day Positive Thinking', 'Challenge negative thoughts daily', 7, 1, 'Improve mindset'),
(18, '90-Day Savings Challenge', 'Save money daily for three months', 90, 1, 'Build financial health'),
(19, '14-Day Connection Challenge', 'Reach out to one person daily', 14, 1, 'Strengthen relationships'),
(20, '30-Day Creativity Boost', 'Engage in creative activity daily', 30, 1, 'Enhance creativity');

INSERT INTO Resource (ResourceID, ResourceType, ResourceLink, ResourceDescription) VALUES
(1, 'Article', 'https://example.com/mindfulness-benefits', 'Scientific benefits of mindfulness meditation'),
(2, 'Podcast', 'https://example.com/anxiety-tools', 'Tools for managing anxiety in daily life'),
(3, 'Video', 'https://example.com/journaling-guide', 'Beginner guide to therapeutic journaling'),
(4, 'Article', 'https://example.com/sleep-hygiene', '10 sleep hygiene tips for better rest'),
(5, 'Podcast', 'https://example.com/gratitude-practice', 'How gratitude practice changes your brain'),
(6, 'Video', 'https://example.com/morning-routine', 'Creating a mindful morning routine'),
(7, 'Article', 'https://example.com/digital-detox', 'Complete guide to digital detox'),
(8, 'Podcast', 'https://example.com/work-stress', 'Managing work-related stress effectively'),
(9, 'Video', 'https://example.com/yoga-beginners', 'Yoga for complete beginners - 20 minute routine'),
(10, 'Article', 'https://example.com/emotional-intelligence', 'Developing emotional intelligence skills'),
(11, 'Podcast', 'https://example.com/self-compassion', 'The power of self-compassion'),
(12, 'Video', 'https://example.com/breathing-techniques', '5 breathing techniques for anxiety relief'),
(13, 'Article', 'https://example.com/procrastination', 'Science-based strategies to beat procrastination'),
(14, 'Podcast', 'https://example.com/burnout-recovery', 'Recovering from burnout - personal stories'),
(15, 'Video', 'https://example.com/evening-routine', 'Creating a relaxing evening routine'),
(16, 'Article', 'https://example.com/nature-therapy', 'Nature therapy for mental wellness'),
(17, 'Podcast', 'https://example.com/relationships', 'Building healthier relationships'),
(18, 'Video', 'https://example.com/meditation-postures', 'Proper meditation postures for beginners'),
(19, 'Article', 'https://example.com/mindful-eating', 'Guide to mindful eating practices'),
(20, 'Podcast', 'https://example.com/emotional-trauma', 'Understanding and healing emotional trauma'),
(21, 'Video', 'https://example.com/stretching-routine', '10-minute morning stretching routine'),
(22, 'Article', 'https://example.com/digital-minimalism', 'Digital minimalism for mental clarity'),
(23, 'Podcast', 'https://example.com/happiness-habits', 'Daily habits for long-term happiness'),
(24, 'Video', 'https://example.com/desk-yoga', 'Yoga stretches for office workers'),
(25, 'Article', 'https://example.com/anger-management', 'Healthy ways to manage anger'),
(26, 'Podcast', 'https://example.com/loneliness', 'Overcoming loneliness in modern life'),
(27, 'Video', 'https://example.com/grounding-techniques', 'Grounding techniques for anxiety attacks'),
(28, 'Article', 'https://example.com/creative-therapy', 'Using creativity for emotional healing'),
(29, 'Podcast', 'https://example.com/mindset-shift', 'How to shift your mindset positively'),
(30, 'Video', 'https://example.com/quick-meditation', '5-minute meditation for busy people'),
(31, 'Article', 'https://example.com/social-media-impact', 'Social media''s impact on mental health'),
(32, 'Podcast', 'https://example.com/personal-growth', 'Personal growth through challenges'),
(33, 'Video', 'https://example.com/progressive-relaxation', 'Progressive muscle relaxation guide'),
(34, 'Article', 'https://example.com/emotional-burnout', 'Recognizing signs of emotional burnout'),
(35, 'Podcast', 'https://example.com/positive-psychology', 'Introduction to positive psychology'),
(36, 'Video', 'https://example.com/desk-meditation', 'Meditation you can do at your desk'),
(37, 'Article', 'https://example.com/communication-skills', 'Improving emotional communication'),
(38, 'Podcast', 'https://example.com/self-care-myths', 'Debunking self-care myths'),
(39, 'Video', 'https://example.com/bedtime-yoga', 'Yoga routine for better sleep'),
(40, 'Article', 'https://example.com/grief-process', 'Understanding the grief process'),
(41, 'Podcast', 'https://example.com/mindful-parenting', 'Mindful parenting strategies'),
(42, 'Video', 'https://example.com/emotional-first-aid', 'Emotional first aid techniques'),
(43, 'Article', 'https://example.com/decision-fatigue', 'Managing decision fatigue'),
(44, 'Podcast', 'https://example.com/emotional-resilience', 'Building emotional resilience'),
(45, 'Video', 'https://example.com/chair-yoga', 'Yoga for limited mobility'),
(46, 'Article', 'https://example.com/seasonal-affective', 'Coping with seasonal affective disorder'),
(47, 'Podcast', 'https://example.com/emotional-eating', 'Understanding emotional eating patterns'),
(48, 'Video', 'https://example.com/visualization', 'Guided visualization for stress relief'),
(49, 'Article', 'https://example.com/attachment-styles', 'How attachment styles affect relationships'),
(50, 'Podcast', 'https://example.com/mindful-technology', 'Mindful use of technology');


-- Simple Retrieval:
SELECT Name, Email FROM User WHERE Gender = 'Male';


-- Constraints ensure data integrity (e.g., PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL).Primary Key Constraint (Already Defined): UserID in User table.Foreign Key Constraint Check:

SELECT u.Name, je.EntryContent
FROM User u
LEFT JOIN JournalEntry je ON u.UserID = je.UserID
WHERE je.UserID IS NULL;
-- Checks for users with no journal entries.

SELECT Name , COUNT(*)
FROM User
GROUP BY Name
HAVING COUNT(*) > 1;
-- Detects duplicate emails violating the UNIQUE constraint.

INSERT INTO User (Name, Email, Password, DateOfBirth, Gender)
VALUES ('Jane Doe', 'jane@example.com', 'hashedpass456', NULL, 'Female');
select * from User;
-- This would fail if DateOfBirth is set to NOT NULL (not specified, but good to check).

-- Basic SELECT with WHERE:
SELECT Name, DateOfBirth
FROM User
WHERE DateOfBirth > '1990-01-01'
ORDER BY DateOfBirth ASC;

-- Using Aliases
SELECT u.Name AS UserName, m.MoodName
FROM User u
JOIN JournalEntry je ON u.UserID = je.UserID
JOIN Mood m ON je.MoodID = m.MoodID;

-- Limiting Results:
SELECT PostContent
FROM CommunityPost
ORDER BY PostDate DESC
LIMIT 5;

-- Simple Query
SELECT Name, Email
FROM User
WHERE Gender = 'Male';

-- Query with Multiple Conditions
SELECT u.Name, je.EntryContent
FROM User u
JOIN JournalEntry je ON u.UserID = je.UserID
WHERE je.Date > '2025-01-01' AND u.Gender = 'Male';

-- Subquery in WHERE
SELECT Name
FROM User
WHERE UserID IN (SELECT UserID FROM JournalEntry WHERE Tags LIKE '%happy%');

-- UPDATE
UPDATE User
SET ProfilePicture = 'newprofile.jpg'
WHERE UserID = 1;

-- DELETE
SET SQL_SAFE_UPDATES = 0;
DELETE FROM JournalEntry
WHERE Date < '2025-01-01';
SET SQL_SAFE_UPDATES = 1;

-- ADD
ALTER TABLE User
ADD COLUMN LastLogin DATETIME;
Select * from User;

-- UPDATE with JOIN
SET SQL_SAFE_UPDATES = 0;
UPDATE JournalEntry je
JOIN Mood m ON je.MoodID = m.MoodID
SET je.EntryContent = CONCAT(je.EntryContent, ' (', m.MoodName, ')')
WHERE m.MoodName = 'Sad';
SET SQL_SAFE_UPDATES = 1;

-- DELETE with Condition
SET SQL_SAFE_UPDATES = 0;
DELETE FROM Reminder
WHERE ReminderTime < NOW();
SET SQL_SAFE_UPDATES = 1;

-- UNION (Combine Unique Users with Journal Entries and Reminders):
SELECT UserID FROM JournalEntry
UNION
SELECT UserID FROM Reminder;

-- UNION ALL (Include Duplicates):
SELECT UserID FROM JournalEntry
UNION ALL
SELECT UserID FROM Reminder;

-- COUNT:
SELECT COUNT(*) AS TotalUsers
FROM User
WHERE Gender = 'Male';

-- AVG
SELECT AVG(Progress) AS AvgProgress
FROM Goal
WHERE EndDate > '2025-04-01';

-- MAX AND MIN
SELECT MAX(ReminderTime) AS LatestReminder, MIN(ReminderTime) AS EarliestReminder
FROM Reminder;

-- Subquery in SELECT
SELECT u.Name, COUNT(j.EntryID) AS EntryCount
FROM User u
LEFT JOIN JournalEntry j ON u.UserID = j.UserID
GROUP BY u.UserID, u.Name;

-- Subquery in From 
SELECT u.Name, m.MoodName
FROM User u
JOIN (SELECT UserID, MoodID FROM JournalEntry WHERE Date = '2025-04-01') je ON u.UserID = je.UserID
JOIN Mood m ON je.MoodID = m.MoodID;

-- Correlated Subquery 
SELECT Name
FROM User u
WHERE 2 > (SELECT COUNT(*) FROM JournalEntry je WHERE je.UserID = u.UserID);
-- Finds users with fewer than 2 journal entries.

-- INNER JOIN
SELECT u.Name, je.EntryContent
FROM User u
INNER JOIN JournalEntry je ON u.UserID = je.UserID;

-- OUTER JOIN 
SELECT u.Name, m.MoodName
FROM User u
JOIN JournalEntry je ON u.UserID = je.UserID
JOIN Mood m ON FIND_IN_SET(m.MoodID, je.MoodID) > 0;



-- Finds users with no mood recorded.

SELECT u.Name, g.GoalDescription
FROM User u
LEFT JOIN Goal g ON u.UserID = g.UserID
UNION
SELECT u.Name, g.GoalDescription
FROM User u
RIGHT JOIN Goal g ON u.UserID = g.UserID
WHERE u.UserID IS NULL;

-- CREATE VIEW 
CREATE VIEW UserMoodSummary AS
SELECT u.Name, m.MoodName, je.Date
FROM User u
JOIN JournalEntry je ON u.UserID = je.UserID
JOIN Mood m ON je.MoodID = m.MoodID;
Select * from UserMoodSummary;

-- Query View 
CREATE VIEW UserEmotionOverview AS
SELECT u.Name, m.MoodName, je.Date
FROM User u
JOIN JournalEntry je ON u.UserID = je.UserID
JOIN Mood m ON je.MoodID = m.MoodID;
Select * from UserEmotionOverview;

