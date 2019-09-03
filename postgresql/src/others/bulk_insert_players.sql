use scraping;
truncate table players;

-- null値を保持
--begin try
bulk insert players
    from '/Users/okuwaki/Projects/Database/article/script/players_previous_id.csv'
    with (
        firstrow = 2, 
        datafiletype = 'widechar', 
        fieldterminator='\t', 
        rowterminator='\n', 
        keepnulls
    );
--end try
--begin catch
--select 
/*
        ERROR_NUMBER()    AS ErrorNumber,
        ERROR_SEVERITY()  AS ErrorSeverity,
        ERROR_STATE()     AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_LINE()      AS ErrorLine,
        ERROR_MESSAGE()   AS ErrorMessage;
        */
--end catch;
