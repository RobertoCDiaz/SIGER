const NodeMailer = require('nodemailer');

/**
 * Plantilla para un correo electrónico.
 */
export interface Mail {
	from: string;
	to: string;
	subject: string;
	content: string;
}


/**
 * Clase capaz de enviar correos electrónicos.
 *
 * Como constructor, se le tienen que pasar el correo y
 * contraseña de la cuenta remitente de correos.
 *
 * Para enviar un email, se usará el método
 * [sendEmail], pasándole el correo a enviar y
 * una función para ejecutar una vez haya concluido el proceso.
 */
export class Mailer {
	private transporter: any;

	constructor(public remitent: string, public remitentPassword: string) {
		this.transporter = NodeMailer.createTransport({
			service: 'gmail',
			auth: {
				user: remitent,
				pass: remitentPassword
			}
		});
	}

	async sendEmail(mailOptions: Mail, onDone: (error, info) => void = () => {}) {
		await this.transporter.sendMail({
			from: mailOptions.from,
			to: mailOptions.to,
			subject: mailOptions.subject,
			html: mailOptions.content
		}, onDone);
	}
}