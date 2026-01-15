#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QMessageBox>
#include <QFile>
#include <QTextStream>
#include <QLineEdit>
#include <QStringList>
#include <QTableWidget>

#define BASE "base\\"
//#define BASE "C:\\Users\\Boro\\Desktop\\customer\\base\\"

Ui::MainWindow *ui;
QFile file;

MainWindow::MainWindow(QWidget *parent):QMainWindow(parent), ui(new Ui::MainWindow) {
    ui->setupUi(this); this->ui = ui;
    ui->CCode->setValidator(new QIntValidator(this));
}

MainWindow::~MainWindow() {
    delete ui;
}

void MainWindow::on_CheckCC_clicked() {
    QMessageBox msgBox;
    QString ccnumber = ui->CCNumber->text();
    int sum = 0, length = ccnumber.length()-1;

    if (length != 15) sum = 1;
    else for (int i=length; i>=0; i--) {
        char digit = ccnumber.at(i).toAscii() - '0';
        if (i % 2 == length % 2) sum += digit;
        else if (digit <= 4) sum += digit * 2;
        else sum += digit * 2 - 9;
    }

    msgBox.setText((sum%10==0)?"Your credit card is valid - Passes the Luhn Algorithm!":"Your credit card is invalid - Does not pass the Luhn Algorithm");
    msgBox.exec();

}

void MainWindow::on_CCode_textChanged(QString a) {
    QMessageBox msgBox;
    file.setFileName(BASE+a+".csv");

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        SetStatus(true);
    } else {
        SetStatus(false);
        msgBox.setText("The file is not a valid comma-separated value file! Exiting...");
        QTextStream in(&file);
        QStringList line = in.readLine().split(";");
        if (line.count() != 3) {
            file.close();
            msgBox.exec();
            this->close();
            return;
        }
        ui->CName->setText(line.at(0));
        ui->CCNumber->setText(line.at(1));

        if (line.at(2) == "true") ui->CActive->setChecked(true);
        else ui->CActive->setChecked(false);

        line = in.readLine().split(";");
        if (line.count() != 3 || line.at(0) != "City Name" || line.at(1) != "Street Name" || line.at(2) != "Pin Code") {
            file.close();
            msgBox.exec();
            this->close();
            return;
        }

        int row = 0;
        while (!in.atEnd()) {
            ui->CAddress->setRowCount(row+1);
            line = in.readLine().split(";");

            if (line.count() != 3) {
                file.close();
                msgBox.exec();
                this->close();
                return;
            }

            QTableWidgetItem *Item1 = new QTableWidgetItem(line.at(0));
            ui->CAddress->setItem(row, 0, Item1);
            QTableWidgetItem *Item2 = new QTableWidgetItem(line.at(1));
            ui->CAddress->setItem(row, 1, Item2);
            QTableWidgetItem *Item3 = new QTableWidgetItem(line.at(2));
            ui->CAddress->setItem(row, 2, Item3);
            row++;
        }
        file.close();

    }

}

void MainWindow::on_DCustomer_clicked() {
    file.remove();
    SetStatus(true);
}

void MainWindow::on_AddC_clicked() {
    QMessageBox msgBox;
    file.setFileName(BASE+ui->CCode->text()+".csv");

    if (!file.open(QIODevice::ReadWrite | QIODevice::Text)) {
        msgBox.setText("Unable to create a customer file. Check if the folder 'base' exists or check your permissions?");
        msgBox.exec();
        return;
    }

    SetStatus(false);
    file.close();
}

void MainWindow::on_AddA_clicked() {
    ui->CAddress->insertRow(ui->CAddress->rowCount());
}

void MainWindow::on_DAddress_clicked() {
    ui->CAddress->removeRow(ui->CAddress->currentRow());
}

void MainWindow::SetStatus(bool status) {
    ui->CName->setText("");
    ui->CCNumber->setText("");
    ui->CActive->setChecked(false);
    ui->CAddress->setRowCount(0);

    if (status == true) {
        ui->frame->setEnabled(false);
        ui->DCustomer->setEnabled(false);
        ui->AddC->setEnabled(true);
    } else {
        ui->frame->setEnabled(true);
        ui->DCustomer->setEnabled(true);
        ui->AddC->setEnabled(false);
    }
}

void MainWindow::on_UCustomer_clicked() {
    QMessageBox msgBox;
    file.setFileName(BASE+ui->CCode->text()+".csv");

    if (!file.remove()) {
        msgBox.setText("Unable to open the file for saving. Check your permissions?");
        msgBox.exec();
        return;
    }

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        msgBox.setText("Unable to open the file for saving. Check your permissions?");
        msgBox.exec();
        return;
    }

    QTextStream out(&file);
    QString CActive;

    if (ui->CActive->isChecked()) CActive = "true";
    else CActive = "false";

    out << ui->CName->text().replace(";","") << ";" << ui->CCNumber->text().replace(";","") << ";" << CActive << endl \
        << "City Name;Street Name;Pin Code" << endl;

    int length = ui->CAddress->rowCount();

    for (int row=0;row<length;row++) {
        QTableWidgetItem *Item1 = ui->CAddress->item(row, 0);
        QTableWidgetItem *Item2 = ui->CAddress->item(row, 1);
        QTableWidgetItem *Item3 = ui->CAddress->item(row, 2);
        out << Item1->text().replace(";","") << ";" << Item2->text().replace(";","") << ";" << Item3->text().replace(";","") << endl;
    }

    file.close();

    msgBox.setText("Customer profile successfully updated!");
    msgBox.exec();
}
