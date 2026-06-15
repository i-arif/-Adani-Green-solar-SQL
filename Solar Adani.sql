create database adani_green_db;
use adani_green_db;
CREATE TABLE solar_plants (
    plant_id       VARCHAR(10) PRIMARY KEY,
    plant_name     VARCHAR(100) NOT NULL,
    state          VARCHAR(50),
    capacity_mw    DECIMAL(10,2),
    type           ENUM('Solar PV', 'Wind', 'Hybrid'),
    install_date   DATE,
    status         VARCHAR(30)
);

CREATE TABLE energy_output (
    output_id              VARCHAR(10) PRIMARY KEY,
    plant_id               VARCHAR(10),
    month                  VARCHAR(10),
    energy_generated_mwh   DECIMAL(12,2),
    energy_transmitted_mwh DECIMAL(12,2),
    revenue_cr             DECIMAL(10,2),
    FOREIGN KEY (plant_id) REFERENCES solar_plants(plant_id)
);
CREATE TABLE maintenance_logs (
    log_id      VARCHAR(10) PRIMARY KEY,
    plant_id    VARCHAR(10),
    maint_type  VARCHAR(80),
    start_date  DATE,
    end_date    DATE,
    cost_lakh   DECIMAL(10,2),
    status      VARCHAR(30),
    FOREIGN KEY (plant_id) REFERENCES solar_plants(plant_id)
);

INSERT INTO solar_plants VALUES
('P001', 'Khavda Solar Phase 1','Gujarat',2000.00, 'Solar PV', '2022-03-15', 'Active'),
('P002', 'Rajasthan Green 1',       'Rajasthan',        1500.00, 'Solar PV', '2021-07-20', 'Active'),
('P003', 'Andhra Wind Farm',        'Andhra Pradesh',    600.00, 'Wind',     '2020-11-10', 'Active'),
('P004', 'Tamil Nadu Hybrid',       'Tamil Nadu',        800.00, 'Hybrid',   '2023-01-05', 'Active'),
('P005', 'Karnataka Solar',         'Karnataka',         400.00, 'Solar PV', '2019-06-18', 'Active'),
('P006', 'MP Wind Phase 2',         'Madhya Pradesh',    700.00, 'Wind',     '2023-08-22', 'Active'),
('P007', 'Maharashtra Hybrid',      'Maharashtra',       500.00, 'Hybrid',   '2022-12-30', 'Active'),
('P008', 'Odisha Solar Farm',       'Odisha',            300.00, 'Solar PV', '2021-04-14', 'Under Maintenance'),
('P009', 'Punjab Solar Grid',       'Punjab',            250.00, 'Solar PV', '2023-05-09', 'Active'),
('P010', 'Himachal Wind Farm',      'Himachal Pradesh',  180.00, 'Wind',     '2020-09-27', 'Active');

INSERT INTO energy_output VALUES
('O001', 'P001', '2024-01', 120000.00, 118500.00, 42.00),
('O002', 'P001', '2024-02', 115000.00, 113200.00, 40.25),
('O003', 'P002', '2024-01',  90000.00,  88000.00, 31.50),
('O004', 'P002', '2024-02',  85000.00,  83500.00, 29.75),
('O005', 'P003', '2024-01',  36000.00,  35200.00, 12.60),
('O006', 'P004', '2024-01',  48000.00,  47100.00, 16.80),
('O007', 'P005', '2024-01',  24000.00,  23500.00,  8.40),
('O008', 'P006', '2024-01',  42000.00,  41200.00, 14.70),
('O009', 'P007', '2024-01',  30000.00,  29400.00, 10.50),
('O010', 'P009', '2024-01',  15000.00,  14700.00,  5.25),
('O011', 'P010', '2024-01',  10800.00,  10500.00,  3.78),
('O012', 'P001', '2024-03', 125000.00, 123000.00, 43.75),
('O013', 'P002', '2024-03',  92000.00,  90000.00, 32.20),
('O014', 'P003', '2024-03',  38000.00,  37200.00, 13.30),
('O015', 'P004', '2024-03',  51000.00,  50000.00, 17.85);

INSERT INTO maintenance_logs VALUES
('M001', 'P001', 'Routine Inspection', '2024-01-10', '2024-01-11',  2.50, 'Completed'),
('M002', 'P003', 'Panel Cleaning', '2024-01-15', '2024-01-16',  1.20, 'Completed'),
('M003', 'P008', 'Inverter Repair', '2024-02-01', '2024-02-05', 15.80, 'Completed'),
('M004', 'P002', 'Cable Replacement', '2024-02-10', '2024-02-13',  8.40, 'Completed'),
('M005', 'P005', 'Routine Inspection', '2024-03-01', '2024-03-02',  2.10, 'Completed'),
('M006', 'P004', 'Transformer Upgrade', '2024-03-15', '2024-03-20', 45.00, 'Completed'),
('M007', 'P006', 'Blade Repair',         '2024-04-01', '2024-04-04', 22.50, 'Completed'),
('M008', 'P007', 'Panel Replacement',    '2024-04-10', '2024-04-14', 30.00, 'In Progress'),
('M009', 'P009', 'Routine Inspection',   '2024-04-20', '2024-04-21',  1.80, 'Completed'),
('M010', 'P010', 'Gearbox Service',      '2024-05-01', '2024-05-03', 18.60, 'Scheduled');

select * from maintenance_logs;
select * from solar_plants;
select* from energy_output;

-- Query 1: List All Active Solar Plants
SELECT plant_id, plant_name, state, capacity_mw, install_date
FROM solar_plants
WHERE status = 'Active';

-- Query 2: Total Installed Capacity by Energy Type
select type,sum(capacity_mw) as total_capacity_mw
from solar_plants

group by type
order by total_capacity_mw desc;


-- Query 3: Plants with Capacity Above 500 MW
select plant_id, plant_name, state, capacity_mw
from solar_plants
where capacity_mw > 500
order by capacity_mw desc;

-- Query 4: Total Revenue Generated in January 2024
SELECT SUM(revenue_cr) AS total_revenue_jan2024
FROM energy_output
WHERE month = '2024-01';

-- Query 5: Top 3 Plants by Energy Generated

select p.plant_name, sum(o.energy_generated_mwh) as total_generated
from energy_output o 
join Solar_plants p  on o.plant_id = p.plant_id
group by p.plant_name
order by total_generated desc
limit 3;

-- Query 6: Transmission Efficiency per Plant

SELECT p.plant_name,
       SUM(o.energy_transmitted_mwh) AS transmitted,
       SUM(o.energy_generated_mwh) AS 'generated',
       ROUND((SUM(o.energy_transmitted_mwh) /
              SUM(o.energy_generated_mwh)) * 100, 2) AS efficiency_pct
FROM energy_output o
JOIN solar_plants p ON o.plant_id = p.plant_id
GROUP BY p.plant_name;

-- Query 7: Plants Currently Under Maintenance

SELECT DISTINCT p.plant_name, p.state, m.maint_type, m.status
FROM maintenance_logs m
JOIN solar_plants p ON m.plant_id = p.plant_id
WHERE m.status IN ('In Progress', 'Scheduled');

-- Query 8: Total Maintenance Cost per Plant
SELECT p.plant_name, SUM(m.cost_lakh) AS total_maint_cost_lakh
FROM maintenance_logs m
JOIN solar_plants p ON m.plant_id = p.plant_id
GROUP BY p.plant_name
ORDER BY total_maint_cost_lakh DESC;

-- Query 10: Monthly Revenue Trend for Plant P001
SELECT month, energy_generated_mwh, revenue_cr
FROM energy_output
WHERE plant_id = 'P001'
ORDER BY month;

-- Query 11: Plants Installed Before 2022
SELECT plant_id, plant_name, state, install_date
FROM solar_plants
WHERE install_date < '2022-01-01'
ORDER BY install_date ASC;


SELECT p.type, ROUND(AVG(o.revenue_cr), 2) AS avg_monthly_revenue_cr
FROM energy_output o
JOIN solar_plants p ON o.plant_id = p.plant_id
GROUP BY p.type;

SELECT p.plant_id, p.plant_name, p.status
FROM solar_plants p
LEFT JOIN energy_output o ON p.plant_id = o.plant_id
WHERE o.plant_id IS NULL;


SELECT p.plant_name, COUNT(m.log_id) AS total_maintenance_events
FROM solar_plants p
LEFT JOIN maintenance_logs m ON p.plant_id = m.plant_id
GROUP BY p.plant_name
ORDER BY total_maintenance_events DESC;

SELECT p.plant_name, o.month, SUM(o.revenue_cr) AS monthly_revenue
FROM energy_output o
JOIN solar_plants p ON o.plant_id = p.plant_id
GROUP BY p.plant_name, o.month
HAVING monthly_revenue > 30
ORDER BY monthly_revenue DESC;


SELECT p.plant_name,
       SUM(o.energy_generated_mwh - o.energy_transmitted_mwh) AS total_loss_mwh
FROM energy_output o
JOIN solar_plants p ON o.plant_id = p.plant_id
GROUP BY p.plant_name
ORDER BY total_loss_mwh DESC;

SELECT m.log_id, p.plant_name, m.maint_type,
       m.start_date, m.cost_lakh
FROM maintenance_logs m
JOIN solar_plants p ON m.plant_id = p.plant_id
WHERE m.cost_lakh = (SELECT MAX(cost_lakh) FROM maintenance_logs);

SELECT
  CASE
    WHEN month IN ('2024-01','2024-02','2024-03') THEN 'Q1 2024'
    WHEN month IN ('2024-04','2024-05','2024-06') THEN 'Q2 2024'
    ELSE 'Other'
  END AS quarter,
  SUM(revenue_cr) AS quarterly_revenue
FROM energy_output
GROUP BY quarter;

SELECT plant_name, state, capacity_mw
FROM solar_plants
WHERE capacity_mw > (SELECT AVG(capacity_mw) FROM solar_plants)
ORDER BY capacity_mw DESC;

SELECT p.plant_id, p.plant_name, p.type, p.state,
       SUM(o.energy_generated_mwh) AS total_generated,
       SUM(o.revenue_cr) AS total_revenue,
       COUNT(m.log_id) AS total_maintenances,
       SUM(m.cost_lakh) AS total_maint_cost
FROM solar_plants p
LEFT JOIN energy_output o ON p.plant_id = o.plant_id
LEFT JOIN maintenance_logs m ON p.plant_id = m.plant_id
GROUP BY p.plant_id, p.plant_name, p.type, p.state
ORDER BY total_revenue DESC;









