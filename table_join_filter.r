
#R 버전
#https://rdrr.io/snippets/ 에서 작성

#0. 데이터프레임

#0.1 컬럼 벡터를 이용한 데이터 프레임 생성
exam_df <- data.frame(c(1, 2, 3, 4, 5, 6, 7, 8, 9),
					c(1, 2, 3, 1, 2, 3, 1, 2, 1),
					c(1, 1, 3, 2, 2, 1, 1, 1, 3),
					c(90, 88, 99, 91, 99, 100, 88, 86, 99))

colnames(exam_df) <- c(“id”, “student_id”, “sub_id”, “score”)  
#exam_df

student_df <- data.frame(c(1, 2, 3),
					c(“조”, “오”, “이”))

colnames(student_df) <- c(“student_id”, “name”)  
#student_df


subject_df <- data.frame(c(1, 2, 3),
					c(“ft_printf”, “minishell”, “minirt”))

colnames(subject_df) <- c(“sub_id”, “name”)  
#subject_df

#0.2 데이터베이스 연결을 통한 데이터 프레임 생성
# or getting data.frame (df) from a database
# https://db.rstudio.com/dplyr/


#0.3. 데이터 핸들링과 파이프 연산 (%>%)을 위한 dplyr 패키지 로딩
library(dplyr)


#1. ‘2회 이상의 시험을 본’ 학생의 과목별 평균을 구하시오. 출력 형태는 이름, 과목명, 평균점수

#1.1 원하는 결과를 추출하여 데이터 프레임으로 저장

mydf <- exam_df %>% 
		group_by(student_id, sub_id) %>% 
		summarise(sub_cnt = n(), sub_avg = mean(score)) %>%
		mutate(stu_cnt = sum(sub_cnt)) %>%
		filter(stu_cnt > 1) %>%
		as_data_frame

#1.2 출력을 위한 조인
		
mydf2 <- mydf %>%
	inner_join(student_df, by = “student_id”) %>%
	rename(student_name = name) %>%
	inner_join(subject_df, by = “sub_id”) %>%
	rename(sub_name = name) %>%
	select(이름=student_name, 과목명=sub_name, 평균점수=sub_avg)
mydf2

#2. ‘과목별로 2회 이상의 시험을 본’ 학생의 과목별 평균을 구하시오. 출력 형태는 이름, 과목명, 평균점수

#2.1 원하는 결과를 추출하여 데이터 프레임으로 저장
mydf <- exam_df %>% 
		group_by(student_id, sub_id) %>% 
		summarise(sub_cnt = n(), sub_avg = mean(score)) %>%
		filter(sub_cnt > 1) %>%
		as_data_frame

#2.2 출력을 위한 조인

mydf2 <- mydf %>%
	inner_join(student_df, by = “student_id”) %>%
	rename(student_name = name) %>%
	inner_join(subject_df, by = “sub_id”) %>%
	rename(sub_name = name) %>%
	select(이름=student_name, 과목명=sub_name, 평균점수=sub_avg)
mydf2
