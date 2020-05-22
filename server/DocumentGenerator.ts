const PizZip        = require('pizzip');
const Docxtemplater = require('docxtemplater');
const Filesystem    = require('fs');

/**
 * Genera un documento a partir de una plantilla y un conjunto de
 * parámetros que sustituirán los placeholders en la plantilla.
 * 
 * @param data Objeto JSON con la información a poner en la plantilla.
 * @param inputDir Archivo .docx que servirá como plantilla.
 */
export const generateDocument = (data: Object, inputDir) => new Promise(async (resolve, reject) => {
    let content = Filesystem.readFileSync(inputDir, 'binary');

    try {
        let zip = new PizZip(content);
    
        let doc = new Docxtemplater();
        doc.loadZip(zip);
    
        doc.setData(data);

        doc.render()

        let buf = doc.getZip().generate({type: 'nodebuffer'});
    
        resolve(buf);    
    } catch (error) {
        reject(error.toString());
    }
});