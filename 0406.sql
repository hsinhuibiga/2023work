
SELECT TOP 1 [YYYY] =CONVERT(INT, [YYYY]), [MM] = CONVERT(INT, [MM]), [最新值] = [RE_AMT]
FROM [dbo].['Select bifan_r59b032_v$']
ORDER BY [YYYY] DESC, [MM] DESC;