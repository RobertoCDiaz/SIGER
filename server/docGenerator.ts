var PizZip = require('pizzip');
var Docxtemplater = require('docxtemplater');

var fs = require('fs');
var path = require('path');

export const generateDoc = (data, inputDir, outputDir) => new Promise(async (resolve, reject) => {
    var content = fs
    .readFileSync(/*path.resolve(__dirname, 'input.docx')*/inputDir, 'binary');

    var zip = new PizZip(content);

    var doc = new Docxtemplater();
    doc.loadZip(zip);

    doc.setData(data);

    try {
        doc.render()

        var buf = doc.getZip().generate({type: 'nodebuffer'});

        await fs.writeFileSync(/*path.resolve(__dirname, 'output.docx')*/ outputDir, buf);
    
        resolve(buf);    
    } catch (error) {
        reject(error);
    }
});