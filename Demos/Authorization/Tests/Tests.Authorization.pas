(*
  Copyright 2015-2016, MARS - REST Library

  Home: https://github.com/MARS-library

*)
unit Tests.Authorization;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, Variants, Server.Forms.Main, Windows,
  MARS.http.Server.Indy, Dialogs, Forms, SysUtils, ExtCtrls,
  IdContext, Controls, Classes, Messages,
  Diagnostics, Graphics, MARS.Core.Engine, ActnList, StdCtrls,
  MARS.Core.Application
  , idHttp;

type
  TestAuthorization = class(TTestCase)
  private
    FHttp: TIdHTTP;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestPublic;
    procedure TestAdminDeny;
    procedure TestAdminGrant;
  end;


implementation

uses DateUtils;

{ TestAuthorization }

procedure TestAuthorization.SetUp;
begin
  inherited;
  FHttp := TIdHTTP.Create(nil);
end;

procedure TestAuthorization.TearDown;
begin
  inherited;
  FHttp.Free;
end;

procedure TestAuthorization.TestAdminDeny;
begin
  ExpectedException := EIdHTTPProtocolException;
  FHttp.Get('http://localhost:8080/rest/default/first/details');
  CheckEquals(403, FHttp.ResponseCode);
end;

procedure TestAuthorization.TestAdminGrant;
var
  LParams: TStringList;
begin
  LParams := TStringList.Create;
  try
    LParams.Add('username=admin');
    LParams.Add('password=' + IntToStr(HourOf(Now))); // default MARS authentication algorithm

    FHttp.Post('http://localhost:8080/rest/default/token', LParams);
    CheckEquals(200, FHttp.ResponseCode); // now authenticated

    FHttp.Get('http://localhost:8080/rest/default/first/details');
    CheckEquals(200, FHttp.ResponseCode);
  finally
    LParams.Free;
  end;
end;

procedure TestAuthorization.TestPublic;
begin
    FHttp.Get('http://localhost:8080/rest/default/first');
    CheckEquals(200, FHttp.ResponseCode);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestAuthorization.Suite);
end.

