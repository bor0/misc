import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.MessageBox;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import javax.mail.*;
import javax.mail.internet.*;
import org.eclipse.swt.events.KeyAdapter;
import org.eclipse.swt.events.KeyEvent;

public class Main {

	protected Shell shlMailSender;
	private Text mailFrom;
	private Text mailTo;
	private Text mailSubject;
	private Text mailServer;
	private Text mailBody;
	private Button btnNewButton;
	private Text cycle;

	/**
	 * Launch the application.
	 * @param args
	 */
	public static void main(String[] args) {
		try {
			Main window = new Main();
			window.open();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public int send(String smtpHost, int smtpPort, String from, String to, String subject, String content) {
		btnNewButton.setEnabled(false);
		String tmp = "", body = "";
		try {

		// Create a mail session
		java.util.Properties props = new java.util.Properties();
		props.put("mail.transport.protocol", "smtp");
		props.put("mail.smtp.host", smtpHost);
		props.put("mail.smtp.port", ""+smtpPort);
		Session session = Session.getDefaultInstance(props, null);
		
		// Construct the message
		Message msg = new MimeMessage(session);
		for (int i=0;i<from.length();i++) {
			if (from.charAt(i) == '?') tmp += (char)(((Math.random()*100)%26)+'a');
			else tmp += from.charAt(i);
		}
		for (int i=0;i<content.length();i++) {
			if (content.charAt(i) == '?') body += (char)(((Math.random()*100)%26)+'a');
			else body += content.charAt(i);
		}

		msg.setFrom(new InternetAddress(tmp));
		msg.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
		msg.setSubject(subject);
		msg.setText(body);

		// Send the message
	    Transport transport = session.getTransport();
	    transport.connect(smtpHost, 25, null, null);
	    transport.sendMessage(msg, msg.getRecipients(Message.RecipientType.TO));
	    transport.close();

		} catch (Exception e) {
			btnNewButton.setEnabled(true);
			poraka(e.toString().substring(e.toString().indexOf(" ")), 1);
			return 0;
		}
		btnNewButton.setEnabled(true);
		return 1;
	}

	/**
	 * Open the window.
	 */
	public void open() {
		Display display = Display.getDefault();
		createContents();
		shlMailSender.open();
		shlMailSender.layout();
		while (!shlMailSender.isDisposed()) {
			if (!display.readAndDispatch()) {
				display.sleep();
			}
		}
	}

	public void poraka(String msg, int icon) {
        MessageBox mb = new MessageBox(shlMailSender, (icon == 0)?SWT.ICON_INFORMATION:SWT.ICON_ERROR);
        mb.setText(shlMailSender.getText());
        mb.setMessage(msg);
        mb.open();
	}

	/**
	 * Create contents of the window.
	 */
	protected void createContents() {
		shlMailSender = new Shell(SWT.TITLE | SWT.CLOSE | SWT.BORDER);

		shlMailSender.setLayoutDeferred(true);
		shlMailSender.setSize(291, 401);
		shlMailSender.setText("Mail Sender by Boro Sitnikovski");
		shlMailSender.setLayout(null);

		mailFrom = new Text(shlMailSender, SWT.BORDER);
		mailFrom.setBounds(65, 10, 210, 19);
		
		Label lblNewLabel = new Label(shlMailSender, SWT.NONE);
		lblNewLabel.setBounds(10, 13, 49, 13);
		lblNewLabel.setText("Mail from:");
		
		Label lblMailTo = new Label(shlMailSender, SWT.NONE);
		lblMailTo.setBounds(10, 32, 49, 13);
		lblMailTo.setText("Mail to:");
		
		Label lblSubject = new Label(shlMailSender, SWT.NONE);
		lblSubject.setBounds(10, 51, 49, 13);
		lblSubject.setText("Subject:");
		
		Label lblServer = new Label(shlMailSender, SWT.NONE);
		lblServer.setBounds(10, 70, 49, 13);
		lblServer.setText("Server:");
		
		Label lblNewLabel_1 = new Label(shlMailSender, SWT.NONE);
		lblNewLabel_1.setBounds(10, 89, 49, 13);
		lblNewLabel_1.setText("Body:");
		
		mailTo = new Text(shlMailSender, SWT.BORDER);
		mailTo.setBounds(65, 29, 210, 19);
		
		mailSubject = new Text(shlMailSender, SWT.BORDER);
		mailSubject.setBounds(65, 48, 210, 19);
		
		mailServer = new Text(shlMailSender, SWT.BORDER);
		mailServer.setBounds(65, 67, 210, 19);
		
		mailBody = new Text(shlMailSender, SWT.BORDER | SWT.H_SCROLL | SWT.V_SCROLL | SWT.CANCEL | SWT.MULTI);
		mailBody.setBounds(10, 108, 265, 229);
		
		btnNewButton = new Button(shlMailSender, SWT.NONE);
		btnNewButton.setBounds(207, 343, 68, 23);
		btnNewButton.setText("Send!");
		
		cycle = new Text(shlMailSender, SWT.BORDER);
		cycle.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if (Character.isLetter(e.character) == true) e.doit = false;
			}
		});
		cycle.setText("1");
		cycle.setBounds(10, 343, 76, 19);
		btnNewButton.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				int c = 0;
				String tmp = cycle.getText(), tmp2 = "";
				for (int i=0;i<tmp.length();i++) if (Character.isDigit(tmp.charAt(i))) tmp2 += tmp.charAt(i);
				if (tmp2.equals("")) tmp2 = "1";
				cycle.setText(tmp2);
				for (int i=0;i<Integer.valueOf(tmp2);i++)
				c += send(mailServer.getText(), 25, mailFrom.getText(), mailTo.getText(), mailSubject.getText(), mailBody.getText());
				if (c != 0) poraka("Successfully sent " + c + " mail(s)!", 0);
			}
		});

	}
}
