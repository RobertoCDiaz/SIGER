export class Response {
    code: number;
    message: string;
    object: Object;

    constructor(code: number, msg: string, obj: Object = {}) {
        this.code = code;
        this.message = msg;
        this.object = obj;
    }

    static fromJSON = (obj: Object): Response => 
        new Response(obj['code'], obj['message'], obj['object']);

    static fromStringifiedJSON = (str: string): Response =>
        Response.fromJSON(JSON.parse(str));    
        
    /* ================================================================================================
    
        Methods.
    
    ================================================================================================ */
    isSuccessful = () : boolean => 
        this.code == Response.codes.SUCCESS;

    /* ================================================================================================
    
        Common responses.
    
    ================================================================================================ */
    static success = (obj: Object = {}, msg: string = "Success"): Response =>
        new Response(Response.codes.SUCCESS, msg, obj);

    static unknownError = (msg: string): Response =>
        new Response(Response.codes.UNKNOWN_ERROR, msg);

    static userError = (msg: string): Response =>
        new Response(Response.codes.USER_ERROR, msg);

    static sqlError = (msg: string): Response => 
        new Response(Response.codes.SQL_ERROR, msg);

    static authError = (msg: string = "No cuenta con los privilegios necesarios para realizar esta acción"): Response => 
        new Response(Response.codes.AUTH_ERROR, msg);

    static notEnoughParams = (): Response => 
        new Response(Response.codes.NOT_ENOUGH_PARAMS, "A la petición le faltan parámetros para llevarse a cabo correctamente");

    static codes = {
        NOT_ENOUGH_PARAMS: 0,
        SUCCESS: 1,

        UNKNOWN_ERROR: -1,
        SQL_ERROR: -2,
        USER_ERROR: -3,
        AUTH_ERROR: -4,
    }
}