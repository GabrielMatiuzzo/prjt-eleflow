CREATE OR REPLACE VIEW vw_rotas_mais_utilizadas AS
WITH rotas_mais_utilizadas AS (
    SELECT
        ac.razao_social AS Razao_Social_Companhia,
        ai_origem.name AS Nome_Aeroporto_Origem,
        ai_origem.icao AS ICAO_Aeroporto_Origem,
        ai_origem.state AS Estado_UF_Aeroporto_Origem,
        ai_destino.name AS Nome_Aeroporto_Destino,
        ai_destino.icao AS ICAO_Aeroporto_Destino,
        ai_destino.state AS Estado_UF_Aeroporto_Destino,
        ROW_NUMBER() OVER (PARTITION BY ac.razao_social ORDER BY COUNT(*) DESC) AS Rota_Rank
    FROM vra v
    INNER JOIN air_cia ac ON v.icao_empresa_aerea = ac.icao
    INNER JOIN aerodromo_info ai_origem ON v.icao_aerodromo_origem  = ai_origem.icao
    INNER JOIN aerodromo_info ai_destino ON v.icao_aerodromo_destino = ai_destino.icao
    GROUP BY
        ac.razao_social,
        ai_origem.name,
        ai_origem.icao,
        ai_origem.state,
        ai_destino.name,
        ai_destino.icao,
        ai_destino.state
)
SELECT
    Razao_Social_Companhia,
    Nome_Aeroporto_Origem,
    ICAO_Aeroporto_Origem,
    Estado_UF_Aeroporto_Origem,
    Nome_Aeroporto_Destino,
    ICAO_Aeroporto_Destino,
    Estado_UF_Aeroporto_Destino
FROM rotas_mais_utilizadas
WHERE Rota_Rank = 1;