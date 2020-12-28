// Napisana od Boro Sitnikovski
// 18.05.2009 Vezba VII

#include <iostream>

using namespace std;

class Conv {
public:

float sredenkurs;

Conv(float sredenkurs) {
this->sredenkurs = sredenkurs;
}

inline float pretvori(float valuta) {
return valuta*sredenkurs;
}

inline float pretvoriObratno(float valuta) {
return valuta/sredenkurs;
}

};

class ConvEvro : public Conv { public: ConvEvro():Conv(61.5) {} };
class ConvDolar : public Conv { public: ConvDolar():Conv(46.1) {} };
class InterConv : public Conv { public: InterConv(Conv a, Conv b):Conv(a.sredenkurs/b.sredenkurs) {} };

int main() {
ConvEvro evr;
ConvDolar dlr;
float br;
cout <<"Vnesi broj ";
cin >>br;
cout << br <<" evra= "<<evr.pretvori(br)<<" denari"<<endl;
cout << br <<" denari = "<<evr.pretvoriObratno(br) << " evra"<<endl;
cout << br <<" dolari = "<<dlr.pretvori(br) << " denari" <<endl;
cout << br <<" denari = "<<dlr.pretvoriObratno(br) << " dolari"<<endl;

Conv cv1(61.5), cv2(46.1);
InterConv inCv(cv1, cv2);
cout << br <<" evra = " << inCv.pretvori(br) << " dolari"<<endl;
cout << br <<" dolari = " << inCv.pretvoriObratno(br) << " evra"<<endl;

return 0;
}
