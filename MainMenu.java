import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class MainMenu extends JFrame {
    public MainMenu() {
        setTitle("Main Menu");
        setBounds(535, 300, 400, 150);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLayout(new BorderLayout());

        
        // Create components
        JPanel panel = new JPanel();
        panel.setLayout(new GridLayout(2, 1));

        JButton passwordButton = new JButton("Generate Password");
        JButton usernameButton = new JButton("Generate Username");

        passwordButton.setBackground(new Color(66, 66, 66)); // Dark gray background color
        passwordButton.setForeground(Color.WHITE); // White text color
        usernameButton.setBackground(new Color(66, 66, 66)); // Dark gray background color
        usernameButton.setForeground(Color.WHITE); // White text color

        panel.add(passwordButton);
        panel.add(usernameButton);

        add(panel, BorderLayout.CENTER);

        passwordButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose(); // Close the main menu
                showPasswordGenerator(); // Open password generator popup
            }
        });

        usernameButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                dispose(); // Close the main menu
                showUsernameGenerator(); // Open username generator popup
            }
        });

        setVisible(true);
    }

    private void showPasswordGenerator() {
        PasswordPolicy policy = new PasswordPolicy(8, true,true, true, true);
        new PasswordGenerator(policy);
    }

    private void showUsernameGenerator() {
        UsernamePolicy policy = new UsernamePolicy(8, true, true, true, true);
        new UsernameGenerator(policy);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            new MainMenu();
        });
    }
}
