# NASA Exoplanet SQL Analytics

## Project Overview
This project maps the correlation between stellar temperatures and planetary orbital characteristics across thousands of celestial bodies. The data was sourced from the NASA Exoplanet Archive and processed in a local PostgreSQL environment.

## Methodology
1. **Data Cleaning:** Extracted core planetary and stellar metrics from the raw NASA dataset, stripping out secondary error bounds and metadata.
2. **Database Normalization:** Split the flat CSV into a relational architecture featuring a `Stars` table (Parent) and `Planets` table (Child), linked explicitly by the `hostname` primary/foreign key. Handle constraints using `ON CONFLICT DO NOTHING`.
3. **Analytics Pipeline:** Utilized Common Table Expressions (CTEs), `INNER JOINS`, and data aggregations (`GROUP BY`) to isolate structural trends in multi-planet star systems.

## Key Findings
* Executed relational queries successfully mapping orbital periods and mass ratios against distinct stellar classifications (M-Dwarf, K-Dwarf, G-Dwarf).