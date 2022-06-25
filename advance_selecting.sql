--1 количество исполнителей в каждом жанре;
SELECT Genre, COUNT(Artist_id) FROM MusicGenreList gl
JOIN ArtistGenre ag ON gl.Genre_id = ag.Genre_id
GROUP BY Genre;

--2 количество треков, вошедших в альбомы 2019-2020 годов;
SELECT COUNT(Track_name) FROM AlbumTrackList tl
JOIN AlbumList al ON tl.Album_id = al.Album_id
WHERE Album_release_year BETWEEN 2019 AND 2020;

--3 средняя продолжительность треков по каждому альбому;
SELECT Album_name, ROUND(AVG(Track_duration), 1) FROM AlbumList al
JOIN AlbumTrackList tl ON al.Album_id = tl.Album_id
GROUP BY Album_name

--4 все исполнители, которые не выпустили альбомы в 2020 году;
SELECT Artist_name FROM MusicArtistList WHERE Artist_id NOT IN (
SELECT ma.Artist_id FROM MusicArtistList ma
JOIN AlbumArtist aa ON ma.Artist_id = aa.Artist_id
JOIN AlbumList al ON aa.Album_id = al.Album_id
WHERE al.Album_release_year = 2020 AND aa.Creator = TRUE
);

--5 названия сборников, в которых присутствует конкретный исполнитель (выберите сами);
SELECT Collection_name FROM TrackCollections tc
WHERE tc.Collection_id IN (
SELECT tc.Collection_id FROM TrackCollections tc
JOIN CollectionTrackList ct ON tc.Collection_id = ct.Collection_id
JOIN AlbumTrackList tl ON ct.Track_id = tl.Track_id
JOIN AlbumArtist aa ON tl.Album_id = aa.Album_id
WHERE Artist_id = 6
);

--6 название альбомов, в которых присутствуют исполнители более 1 жанра;
SELECT Album_name FROM AlbumList al
JOIN AlbumArtist aa ON al.Album_id = aa.Album_id
JOIN MusicArtistList ma ON aa.Artist_id = ma.Artist_id
WHERE Artist_name IN (
SELECT Artist_name FROM MusicArtistList ma
JOIN ArtistGenre ag ON ma.Artist_id = ag.Artist_id
GROUP BY ma.Artist_name
HAVING COUNT(Genre_id) > 1
);


--7 наименование треков, которые не входят в сборники;
SELECT Track_name FROM AlbumTrackList tl
WHERE Track_id NOT IN (
SELECT Track_id FROM CollectionTrackList
);

--8 исполнителя(-ей), написавшего самый короткий по продолжительности трек
--(теоретически таких треков может быть несколько);
SELECT Artist_name FROM MusicArtistList ma
JOIN AlbumArtist aa ON ma.Artist_id = aa.Artist_id
JOIN AlbumList al ON aa.Album_id = al.Album_id
JOIN AlbumTrackList tl ON al.Album_id = tl.Album_id
WHERE tl.Track_duration = (
SELECT MIN(Track_duration) FROM AlbumTrackList
)
AND aa.Creator = TRUE;

--9 название альбомов, содержащих наименьшее количество треков
SELECT Album_name FROM AlbumList al
JOIN AlbumTrackList tl ON al.Album_id = tl.Album_id
GROUP BY Album_name
HAVING COUNT(Track_duration) = (
SELECT MIN(counter) FROM (
SELECT COUNT(Track_id) counter FROM AlbumTrackList tl
JOIN AlbumList al ON tl.Album_id = al.Album_id
GROUP BY tl.Album_id) AS ASS
);
