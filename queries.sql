-- 1. Create the Master Staging Table
CREATE TABLE Master_Planets (
    pl_name VARCHAR(100),
    hostname VARCHAR(100),
    sy_pnum INTEGER,
    discoverymethod VARCHAR(50),
    disc_year INTEGER,
    disc_facility VARCHAR(150),
    pl_orbper NUMERIC,
    pl_rade NUMERIC,
    pl_bmasse NUMERIC,
    pl_orbeccen NUMERIC,
    st_teff NUMERIC,
    st_mass NUMERIC,
    sy_dist NUMERIC
);

-- 2. Normalize Database: Create Stars Table (Parent)
CREATE TABLE Stars (
    hostname VARCHAR(100) PRIMARY KEY,
    st_teff NUMERIC,
    st_mass NUMERIC,
    sy_dist NUMERIC,
    sy_pnum INTEGER
);

INSERT INTO Stars (hostname, st_teff, st_mass, sy_dist, sy_pnum)
SELECT DISTINCT hostname, st_teff, st_mass, sy_dist, sy_pnum
FROM Master_Planets
WHERE hostname IS NOT NULL
ON CONFLICT (hostname) DO NOTHING;

-- 3. Normalize Database: Create Planets Table (Child)
CREATE TABLE Planets (
    pl_name VARCHAR(100) PRIMARY KEY,
    hostname VARCHAR(100) REFERENCES Stars(hostname),
    discoverymethod VARCHAR(50),
    disc_year INTEGER,
    disc_facility VARCHAR(150),
    pl_orbper NUMERIC,
    pl_rade NUMERIC,
    pl_bmasse NUMERIC,
    pl_orbeccen NUMERIC
);

INSERT INTO Planets (pl_name, hostname, discoverymethod, disc_year, disc_facility, pl_orbper, pl_rade, pl_bmasse, pl_orbeccen)
SELECT pl_name, hostname, discoverymethod, disc_year, disc_facility, pl_orbper, pl_rade, pl_bmasse, pl_orbeccen
FROM Master_Planets
WHERE pl_name IS NOT NULL;

-- 4. Advanced Analytics: Stellar Types vs Planetary Mass
WITH Star_Categories AS (
    SELECT
        hostname,
        st_teff,
        CASE
            WHEN st_teff < 3700 THEN 'M-Dwarf (Cool/Red)'
            WHEN st_teff BETWEEN 3700 AND 5200 THEN 'K-Dwarf'
            WHEN st_teff BETWEEN 5200 AND 6000 THEN 'G-Dwarf (Sun-like)'
            ELSE 'F/A/B-Type (Hot/Blue)'
        END AS star_type
    FROM Stars
    WHERE st_teff IS NOT NULL
)
SELECT
    sc.star_type,
    COUNT(DISTINCT sc.hostname) AS total_stars,
    COUNT(p.pl_name) AS total_planets,
    ROUND(AVG(p.pl_orbper), 2) AS avg_orbital_period_days,
    ROUND(AVG(p.pl_bmasse), 2) AS avg_planet_mass_earth
FROM Star_Categories sc
INNER JOIN Planets p ON sc.hostname = p.hostname
WHERE p.pl_orbper IS NOT NULL AND p.pl_bmasse IS NOT NULL
GROUP BY sc.star_type
ORDER BY avg_orbital_period_days ASC;
