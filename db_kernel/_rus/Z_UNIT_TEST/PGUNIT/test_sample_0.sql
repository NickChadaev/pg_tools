SET search_path=pgunit, public;
DROP FUNCTION IF EXISTS pgunit.test_sample ();
CREATE FUNCTION pgunit.test_sample () RETURNS testfunc[]
AS
$body$
SELECT pgunit.testcase(
    $setUp$
        -- setUp code is executed before ANY test function code (see below).
        -- Effect of this execution is persistent only during the code
        -- block execution and rolled back after the test is finished.
        CREATE TABLE tst(id INTEGER);
    $setUp$,
    ARRAY[
        -- This is a first test function code. Just check if we can insert
        -- into the table created in setUp.
        'first test: insert is okay', $sql$
            INSERT INTO tst VALUES(1);
            PERFORM pgunit.assert_same(1, (SELECT * FROM tst));
        $sql$,

        -- This is a second test function code.
        -- Illustrates that the effect of the first function is not visible.
        'second test: effect of previous function is not visible here', $sql$
            PERFORM pgunit.assert_same(NULL, (SELECT * FROM tst));
        $sql$,

        -- This is a third test function code. Illustrate that we may use DECLARE.
        'first test: you may use DECLARE in tests', $sql$
            DECLARE
                i INTEGER;
            BEGIN
                FOR i IN 1 .. 10 LOOP
                    INSERT INTO tst VALUES(i);
                    PERFORM pgunit.assert_same(i, (SELECT * FROM tst WHERE id = i));
                END LOOP;
            END;
        $sql$
    ]
);
$body$
    LANGUAGE sql;
    