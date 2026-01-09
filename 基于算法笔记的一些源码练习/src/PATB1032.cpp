
/**
   * 第一行输入 比赛总人数 N < 10^5
   * N行给出参赛者的信息和成绩(学校编号  百分制成绩)
   * 
   * 输出最高成绩学校编号与得分
   **/ 
  

#include<iostream>
#include<vector>
#include<algorithm>
#include<unordered_map>

void MyLogic(){

  // 学生总数
  int N = 6;
  // 学生与学校编号绑定;假定有10所
  int School_ID[N]={3,2,1,2,3,3};
  // 每个学生的成绩
  double Score[N]={65,80,100,70,40,0};

  
  // 最终结果标识
  int k;

  // 对学生成绩和学校ID作绑定
  std::vector<std::pair<int,double>> vec_bound_IC;
  for(int i=0;i<N;i++){
    vec_bound_IC.emplace_back(School_ID[i],Score[i]);
  }
  // 对容器内序号进行排序
  std::sort(vec_bound_IC.begin(),vec_bound_IC.end(),
        [](const std::pair<int,double> &a,const std::pair<int,double> &b){
          return a.first <= b.first;
        });

    
  // 计算学校的总分数
  int current_school = vec_bound_IC[0].first;
  double current_score = vec_bound_IC[0].second;
  int best_school = current_school;
  double max_score = current_score;

  for(int k=1;k<vec_bound_IC.size();k++){
    // 相同的学校加和
    int school = vec_bound_IC[k].first;
    double score = vec_bound_IC[k].second;
    
    if(school == current_school){
      current_score += score;
    }else{
      // 如果是新学校，检查一下成绩是否最大
      if(current_score>max_score){
        max_score = current_score;
        best_school = current_school;
      }

      current_school = school;
      current_score = score;

    }
   
    
  }
  // 检查下最后的学校
  if(current_score > max_score){
    max_score = current_score;
    best_school = current_school;
  }
  //输出学校ID,学校总成绩
  printf("School: %d, Score: %f \n",best_school,max_score);
}


void HashMap(){

  // 学生总数
  int N = 6;
  // 学生与学校编号绑定;假定有10所
  int School_ID[N]={3,2,1,2,3,3};
  // 每个学生的成绩
  double Score[N]={65,80,100,70,40,0};

  // 最终结果标识
  int k;
  std::unordered_map<int,double> SchoolTotalScore;
  // 遍历学校成绩
  for(int i=0;i<N;i++){
    int school = School_ID[i];
    double score = Score[i];
    SchoolTotalScore[school] += score;
  }
  
  // 找出最大成绩和对应编号
  int best_school = -1;
  double max_score = -1;
  for(auto &pair : SchoolTotalScore){
    if(pair.second > max_score)
    {
        best_school=pair.first;
        max_score=pair.second;
    }
  }

  if(max_score != -1){
    printf("[Sc So]:[%d %f]\n",best_school,max_score);
  }


}

void AnsWer(){
  // 令数组school[maxn]记录每个学校的总分,初值为零.对每一个读入的学校schID与其对应的分数Score,令School[schID] +=score
  // 令变量k记录最高总分的学校编号,变量MAX记录最高总分,初值为-1.由于学校是连续编号的,因此枚举编号1~N,不断更新K和MAX即可
  const int maxn = 100010;
  // 记录每个学校的总分
  double school[maxn] = {0};
  int N = 6;
   // 学生与学校编号绑定;假定有10所
   int School_ID[N]={3,2,1,2,3,3};
   // 每个学生的成绩
   double Score[N]={65,80,100,70,40,0};
 
  for(int i = 0;i<N;i++){
    int school_id = School_ID[i];
    double score = Score[i];

    school[school_id] += score;
  }

  // 最高总分的学校ID以及其总分
  int k=-1; 
  double MAX = -1;

  for(int i=1;i<maxn-1;i++){
    if(school[i]>MAX){
      MAX = school[i];
      k = i;
    }
  }
  printf("%d %f",k,MAX);
}


int main(int argv,char *argc[]){
  MyLogic();
  HashMap();
  AnsWer();
}
