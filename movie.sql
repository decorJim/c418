CREATE DATABASE MovieCatalogue;

USE MovieCatalogue;

CREATE TABLE Genre(
	genreId INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    genreName VARCHAR(30) NOT NULL
);

CREATE TABLE Director(
	directorId INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    firstName VARCHAR(30) NOT NULL,
    lastName VARCHAR(30) NOT NULL
);

CREATE TABLE Rating(
	ratingId INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    ratingName VARCHAR(5) NOT NULL
);

CREATE TABLE Movie(
	movieId INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    genreId INT NOT NULL,
    directorId INT,
    ratingId INT,
    title VARCHAR(128) NOT NULL,
    releaseDate DATE,
    FOREIGN KEY (genreId) REFERENCES Genre(genreId),
    FOREIGN KEY (directorId) REFERENCES Director(directorId),
    FOREIGN KEY (ratingId) REFERENCES Rating(ratingId)
);

CREATE TABLE Actor(
	actorId INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    firstName VARCHAR(30) NOT NULL,
    lastName VARCHAR(30) NOT NULL,
    birthDate DATE
);

CREATE TABLE CastMembers(
	castMemberId INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    actorId INT NOT NULL,
    movieId INT NOT NULL,
    `role` VARCHAR(50) NOT NULL,
    FOREIGN KEY(actorId) REFERENCES Actor(actorId),
    FOREIGN KEY(movieId) REFERENCES Movie(movieId)
);
    
	