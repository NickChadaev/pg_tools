CREATE TYPE exception_type_t AS (
   state   text 
  ,message text 
  ,detail  text
  ,hint    text
);

declare
  _exception record;
begin
  _exception := NULL::_exception_type;

exception when others then
  get stacked diagnostics
         _exception.state   := RETURNED_SQLSTATE
        ,_exception.message := MESSAGE_TEXT
        ,_exception.detail  := PG_EXCEPTION_DETAIL
        ,_exception.hint    := PG_EXCEPTION_HINT;
end;

