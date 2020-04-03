export class Response {
    code: number;
    message: string;
    object: Object;

    constructor(code: number, msg: string, obj: Object = {}) {
        this.code = code;
        this.message = msg;
        this.object = obj;
    }

    static success = (obj: Object = {}, msg: string = "Success"): Response =>
        new Response(Response.codes.SUCCESS, msg, obj);

    static unknownError = (msg: string): Response =>
        new Response(Response.codes.UNKNOWN_ERROR, msg);

    static userError = (msg: string): Response =>
        new Response(Response.codes.USER_ERROR, msg);

    static sqlError = (msg: string): Response => 
        new Response(Response.codes.SQL_ERROR, msg);

    static codes = {
        NO_PARAMS: 0,
        SUCCESS: 1,

        UNKNOWN_ERROR: -1,
        SQL_ERROR: -2,
        USER_ERROR: -3,
    }
}